//
//  StorageService.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 20/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftKeychainWrapper

protocol StorageService {
    func list(onComplete: @escaping (Error?, [Note]?) -> Void)
    func read(identifier: Int, onComplete: @escaping (Error?, Note?) -> Void)
    func create(title: String, content: String, onComplete: @escaping (Error?, Note?) -> Void)
    func edit(identifier: Int, title: String, content: String, onComplete: @escaping (Error?, Note?) -> Void)
    func delete(identifier: Int, onComplete: @escaping (Error?, Note?) -> Void)
    func deleteAll(onComplete: @escaping (Error?, Bool?) -> Void)
}

class RealmStorageService: StorageService {
    
    let encryptionKey: Data
    let keychainWrapper: KeychainWrapper

    // tag::init[]
    /**
     - Initilise the Realm Storage Service
     
     - Parameter kcWrapper: the swift keychain wrapper
     */
    init(kcWrapper: KeychainWrapper, encryptionKey: Data) {
        self.keychainWrapper = kcWrapper
        self.encryptionKey = encryptionKey
    }
    // end::init[]
    
    // tag::list[]
    /**
     - List the stored entities from the realm db
     
     - Parameter onComplete - a closure called after retrieval
     */
    func list(onComplete: @escaping (Error?, [Note]?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                // create a new thread confined realm
                let realm = try self.getRealmInstance()
                
                // synchronization of Realm instance to the latest version on the background thread
                realm.refresh()
                
                // retieve the notes from realm
                let notesResult = realm.objects(Note.self)
                
                // create a new thread safe reference for these notes
                let threadSafeNotes = ThreadSafeReference(to: notesResult)
                
                // return note to the view controller on the main thread
                DispatchQueue.main.async() {
                    let realm = try! self.getRealmInstance()
                    
                    // get the notes using the thread safe reference
                    guard let notes = realm.resolve(threadSafeNotes) else {
                        return
                    }
                    
                    // convert the notes to array format
                    let notesArray = notes.toArray()
                
                    onComplete(nil, notesArray)
                }
            } catch {
                onComplete(error, nil)
            }
        }
    }
    // end::list[]

    // tag::create[]
    /**
     - Create the stored entity
     
     - Paramater title: the title of the note
     - Paramater content: the content of the note
     - Parameter onComplete - a closure called after creation
     */
    func create(title: String, content: String, onComplete: @escaping (Error?, Note?) -> Void) {
        var id = generateId()
        let createdAt = getDate()
                
        // ensure the ID is unique
        while !isIdentifierUnique(identifier: id) {
            id = generateId()
        }
        
        // create the note object
        let note = Note()
        note.id = id
        note.title = title
        note.content = content
        note.createdAt = createdAt
        note.storageProvider = "Realm"
        
        DispatchQueue.global(qos: .background).async {
            // create the note in the db
            do {
                // create a new thread confined realm
                let realm = try self.getRealmInstance()
                try realm.safeWrite {
                    realm.add(note)
                    
                onComplete(nil, note.clone())
                }
            } catch {
                onComplete(error, nil)
            }
        }
    }
    // end::create[]
    
    // tag::read[]
    /**
     - Read the stored entity
     
     - Parameter identifier: The identifier of the note
     - Parameter onComplete - a closure called after retrieval
     */
    func read(identifier: Int, onComplete: @escaping (Error?, Note?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                // create a new thread confined realm
                let realm = try self.getRealmInstance()
                
                // retrieve the notes from realm
                let noteResult = realm.objects(Note.self).filter("id = \(identifier)")
                
                // create a new thread safe reference for these notes
                let threadSafeNotes = ThreadSafeReference(to: noteResult)
                
                // return note to the view controller on the main thread
                DispatchQueue.main.async() {
                    let realm = try! self.getRealmInstance()
                        
                    // get the notes using the thread safe reference
                    guard let notes = realm.resolve(threadSafeNotes) else {
                        return
                    }
                    
                    // extract the note from the list
                    let note = notes.first
                    
                    onComplete(nil, note?.clone())
                }
            } catch {
                onComplete(error, nil)
            }
        }
    }
    // end::read[]
    
    // tag::edit[]
    /**
     - Edit the stored entity
     
     - Parameter identifier: The identifier of the note
     - Parameter title: The title of the note
     - Parameter content: The content of the note
     - Parameter onComplete - a closure called after editing
     */
    func edit(identifier: Int, title: String, content: String, onComplete: @escaping (Error?, Note?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                // create a new thread confined realm
                let realm = try self.getRealmInstance()
                
                // get the existing note to update
                let notes = realm.objects(Note.self).filter("id = \(identifier)")
                let note = notes.first
                
                // update the note with the given id
                try realm.write {
                    note?.title = title
                    note?.content = content
                }
                onComplete(nil, note?.clone())
            } catch {
                onComplete(error, nil)
            }
        }
    }
    // end::edit[]
    
    // tag::delete[]
    /**
     - Delete the stored entity
     
     - Parameter identifier: The identifier of the note
     - Parameter onComplete - a closure called after deletion
     */
    func delete(identifier: Int, onComplete: @escaping (Error?, Note?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                // create a new thread confined realm
                let realm = try self.getRealmInstance()
                
                // get the note to delete
                let noteToDeleteResult = realm.objects(Note.self).filter("id = \(identifier)")
                let note = noteToDeleteResult.first
                let returnNote = note?.clone()
                
                // delete the note
                try realm.write {
                    realm.delete((note)!)
                }
                onComplete(nil, returnNote)
            } catch {
                onComplete(error, nil)
            }
            
        }
    }
    // end::delete[]
    
    // tag::deleteAll[]
    /**
     - Delete all stored entitities
     
     - Parameter onComplete - a closure called after deletion
     */
    func deleteAll(onComplete: @escaping (Error?, Bool?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                // create a new thread confined realm
                let realm = try self.getRealmInstance()
        
                let notes = realm.objects(Note.self)
                
                // delete all the notes
                try realm.write {
                    realm.delete(notes)
                }
                onComplete(nil, true)
            } catch {
                onComplete(error, nil)
            }
        }
    }
    // end::deleteAll[]
    
    func getRealmInstance() throws -> Realm {
        let realm = try Realm(configuration: Realm.Configuration(encryptionKey: self.encryptionKey))
        return realm
    }
    
    /**
     - Check if a note already exists in the db with the same identifier
     
     - Parameter identifier: The identifier of the note
     
     - Returns: true/false based on if a note with the same identifier already exists in the db
     */
    fileprivate func isIdentifierUnique(identifier: Int) -> Bool {
        let realm = try! self.getRealmInstance()
        let identifiers = realm.objects(Note.self).filter("id = \(identifier)")
        return identifiers.count == 0
    }
    
    /**
     - Generate a random ID for an entity that will be created.
     
     - Returns: A new Int with a random number.
    */
    func generateId() -> Int {
        let randomNumberSize = 1000000
        return Int(arc4random_uniform(UInt32(randomNumberSize)))
    }
    
    /**
     - Get the current date to record the create date for an entity that will be created.
     
     - Returns: The current date in Date format.
     */
    func getDate() -> Date {
        let currentDate = Date()
        return currentDate
    }
    
    // tag::generateEncryptionKey[]
    /**
     - Generate an encryption key for the realm db
     
     - Returns: An encryption key
     */
        class func generateEncryptionKey() -> Data {
        let byteLength = 64
        let randomNumberSize = 1000000
        let bytes = [UInt32](repeating: 0, count: byteLength).map { _ in arc4random_uniform(UInt32(randomNumberSize)) }
        let data = Data(bytes: bytes, count: byteLength)
        return data
    }
    // end::generateEncryptionKey[]
    
    // tag::getEncryptionKey[]
    /**
     - Get the encryption key for the realm db
     
     - Parameter kcWrapper: the keychain wrapper instance
     - Parameter keychainAlias: the refernence alias for the encryption key stored in the keychain
     
     - Returns: the encryption key
     */
    class func getEncryptionKey(kcWrapper: KeychainWrapper, keychainAlias: String) -> Data? {
        guard let encryptionKey = kcWrapper.data(forKey: keychainAlias) else {
            let newEncryptionKey = generateEncryptionKey()
            kcWrapper.set(newEncryptionKey, forKey: keychainAlias)
            return newEncryptionKey
        }
        return encryptionKey
    }
    // end::getEncryptionKey[]
}

// extension to provide safe writes to the realm db
extension Realm {
    
    /**
     - Provide a way to only write transaction when one is not already in progress
     */
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}

// extension to convert realm db result format into notes array format
extension Results {
    
    /**
    - Convert the realm result format to an array
     
    - Returns: an array of notes
    */
    func toArray() -> [Note] {
        var array = [Note]()
        for result in self {
            array.append(result as! Note)
        }
        return array
    }
}




