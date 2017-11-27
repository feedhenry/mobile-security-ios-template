//
//  StorageInteractor.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 20/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import RealmSwift

/* Business logic for the storage view. */
protocol StorageInteractor: StorageListener {
    var storageService: StorageService {get}
    var router: StorageRouter? {get set}
}

class StorageInteractorImpl: StorageInteractor {

    let storageService: StorageService
    var router: StorageRouter?
    
    /*
     - Initiliase the Storage Service
     */
    init(storageService: StorageService) {
        self.storageService = storageService
    }
    
    /*
     - List notes stored in storage
     
     - Parameter onComplete - a closure called after retrieval
     */
    func list(onComplete: @escaping (Error?, [Note]?) -> Void) {
        self.storageService.list(onComplete: onComplete)
    }
    
    /*
     - Read an individual note using the storage service
     
     - Parameter onComplete - a closure called after retrieval
     */
    func read(identifier: Int, onComplete: @escaping (Error?, Note?) -> Void) {
        self.storageService.read(identifier: identifier, onComplete: onComplete)
    }
    
    /*
     - Create a new note using the storage service
     
     - Parameter title: the title of the note
     - Parameter content: the content of the note
     - Parameter onComplete - a closure called after creation
    */
    func create(title: String, content: String, onComplete: @escaping (Error?, Note?) -> Void) {
        self.storageService.create(title: title, content: content, onComplete: onComplete)
    }
    
    /*
     - Update an existing note using the storage service
     
     - Parameter identifier: the identifier of the note to update
     - Parameter title: the new title of the note
     - Parameter content: the new content of the note
     - Parameter onComplete - a closure called after updating
     */
    func edit(identifier: Int, title: String, content: String, onComplete: @escaping (Error?, Note?) -> Void) {
        self.storageService.edit(identifier: identifier, title: title, content: content, onComplete: onComplete)
    }
    
    /*
     - Delete a note using the storage service
     
     - Parameter identifier: the identifier of the note to delete
     - Parameter onComplete - a closure called after deletion
     */
    func delete(identifier: Int, onComplete: @escaping (Error?, Note?) -> Void) {
        self.storageService.delete(identifier: identifier, onComplete: onComplete)
    }
    
    /*
     - Delete a note using the storage service
     
     - Parameter identifier: the identifier of the note to delete
     - Parameter onComplete - a closure called after deletion
     */
    func deleteAll(onComplete: @escaping (Error?, Bool?) -> Void) {
        self.storageService.deleteAll(onComplete: onComplete)
    }
}
