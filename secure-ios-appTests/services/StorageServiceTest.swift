//
//  StorageServiceTest.swift
//  secure-ios-appTests
//
//  Created by Wei Li on 03/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import XCTest
import SwiftKeychainWrapper
import RealmSwift
@testable import secure_ios_app

class InMemoryRealmStorageService: RealmStorageService {
    override func getRealmInstance() throws -> Realm {
        let testRealmURL = URL(fileURLWithPath: "/tmp/storage_service_test")
        let config = Realm.Configuration(fileURL: testRealmURL, encryptionKey: self.encryptionKey)
        let testRealm = try! Realm(configuration: config)
        return testRealm
    }
}

class StorageServiceTest: XCTestCase {
    
    let TEST_KEY_CHAIN_NAME = "StorageServiceTest-keychain"
    
    var storageServiceToTest: StorageService!
    var kcwrapper: KeychainWrapper!
    var encryptionKey: Data!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        kcwrapper = KeychainWrapper.standard
        encryptionKey = RealmStorageService.getEncryptionKey(kcWrapper: kcwrapper, keychainAlias: TEST_KEY_CHAIN_NAME)
        storageServiceToTest = InMemoryRealmStorageService(kcWrapper: kcwrapper, encryptionKey: encryptionKey!)
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        doDeleteAll()
    }
    
    override func tearDown() {
        doDeleteAll()
        kcwrapper = nil
        encryptionKey = nil
        storageServiceToTest = nil
        super.tearDown()
    }
    
    func notesArrayToList(notes: [Note]) -> List<Note> {
        let notesList = List<Note>()
        notesList.append(objectsIn: notes)
        return notesList
    }
    
    func doList() -> [Note] {
        var notes: [Note] = [Note()]
        let listPromise = expectation(description: "list notes")
        storageServiceToTest.list() { error, localNotes in
            if let err = error {
                XCTFail("unexpcted error when list notes: \(err.localizedDescription)")
                return
            } else {
                notes = localNotes!
                listPromise.fulfill()
            }
        }
        wait(for: [listPromise], timeout: 1)
        return notes
    }
    
    func doCreate(title: String, content: String) -> Note {
        var note: Note = Note()
        let createPromise = expectation(description: "create notes")
        storageServiceToTest.create(title: title, content: content) { error, noteCreated in
            if let err = error {
                XCTFail("unexpected error when create node: \(err.localizedDescription)")
                return
            } else {
                note = noteCreated!
                createPromise.fulfill()
            }
        }
        wait(for: [createPromise], timeout: 1)
        return note
    }
    
    func doRead(id: Int) -> Note? {
        var note: Note? = Note()
        let readPromise = expectation(description: "read note")
        storageServiceToTest.read(identifier: id) { error, noteRead in
            if let err = error {
                XCTFail("unexpected error when read node: \(err.localizedDescription)")
                return
            } else {
                note = noteRead
                readPromise.fulfill()
            }
        }
        wait(for: [readPromise], timeout: 1)
        return note
    }
    
    func doEdit(id: Int, title: String, content: String) -> Note {
        var note: Note = Note()
        let editPromise = expectation(description: "edit note")
        storageServiceToTest.edit(identifier: id, title: title, content: content) { error, noteUpdated in
            if let err = error {
                XCTFail("unexpected error when update node: \(err.localizedDescription)")
                return
            } else {
                note = noteUpdated!
                editPromise.fulfill()
            }
        }
        wait(for: [editPromise], timeout: 1)
        return note
    }
    
    func doDelete(id: Int) -> Note {
        var note: Note = Note()
        let deletePromise = expectation(description: "delete note")
        storageServiceToTest.delete(identifier: id){ error, noteDeleted in
            if let err = error {
                XCTFail("unexpected error when delete node: \(err.localizedDescription)")
                return
            } else {
                note = noteDeleted!
                deletePromise.fulfill()
            }
        }
        wait(for: [deletePromise], timeout: 1)
        return note
    }
    
    func doDeleteAll() {
        let deleteAllPromise = expectation(description: "delete all notes")
        storageServiceToTest.deleteAll() { error, sucess in
            if let err = error {
                XCTFail("unexpcted error when delete all notes: \(err.localizedDescription)")
                return
            } else {
                deleteAllPromise.fulfill()
            }
        }
        wait(for: [deleteAllPromise], timeout: 1)
    }
    
    func testAll() {
        var currentNotes = doList()
        XCTAssertEqual(currentNotes.count, 0)
        
        let testNoteTitle = "testNote"
        let testNoteContent = "testNoteContent"
        let createdNote = doCreate(title: testNoteTitle, content: testNoteContent)
        XCTAssertNotNil(createdNote.id)
        XCTAssertNotNil(createdNote.createdAt)
        XCTAssertEqual(createdNote.title, testNoteTitle)
        XCTAssertEqual(createdNote.content, testNoteContent)
        
        currentNotes = doList()
        XCTAssertEqual(currentNotes.count, 1)
        
        var noteRead = doRead(id: createdNote.id)!
        XCTAssertEqual(noteRead.id, createdNote.id)
        
        let updateNoteTitle = "testNoteUpdated"
        let updateNoteContent = "testNoteContentUpdated"
        doEdit(id: noteRead.id, title: updateNoteTitle, content: updateNoteContent)
        noteRead = doRead(id: createdNote.id)!
        XCTAssertEqual(noteRead.title, updateNoteTitle)
        XCTAssertEqual(noteRead.content, updateNoteContent)
        
        let removedId = noteRead.id
        doDelete(id: removedId)
        let removedNote = doRead(id: removedId)
        XCTAssertNil(removedNote)
    }
    
}
