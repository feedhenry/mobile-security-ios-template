//
//  StorageViewControllerTest.swift
//  secure-ios-appTests
//
//  Created by Wei Li on 04/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import XCTest
@testable import secure_ios_app

class FakeStorageListener: StorageListener {
    static var noteId: Int = 0
    
    var notes: [Note]!
    
    init(withNotes notes: [Note]) {
        self.notes = notes
    }
    
    func list(onComplete: @escaping (Error?, [Note]?) -> Void) {
        onComplete(nil, notes)
    }
    
    func read(identifier: Int, onComplete: @escaping (Error?, Note?) -> Void) {
        let note = self.notes.first(where: { $0.id == identifier })
        onComplete(nil, note)
    }
    
    func create(title: String, content: String, onComplete: @escaping (Error?, Note?) -> Void) {
        let newNote = Note()
        newNote.title = title
        newNote.content = content
        newNote.createdAt = Date()
        FakeStorageListener.noteId += 1
        newNote.id = FakeStorageListener.noteId
        self.notes.append(newNote)
        onComplete(nil, newNote)
    }
    
    func edit(identifier: Int, title: String, content: String, onComplete: @escaping (Error?, Note?) -> Void) {
        let note = self.notes.first(where: { $0.id == identifier })
        note?.title = title
        note?.content = content
        onComplete(nil, note)
    }
    
    func delete(identifier: Int, onComplete: @escaping (Error?, Note?) -> Void) {
        let noteToRemoveIndex = self.notes.index(where: { $0.id == identifier })
        var noteRemoved: Note?
        if let index = noteToRemoveIndex {
            noteRemoved = self.notes.remove(at: index)
        }
        onComplete(nil, noteRemoved)
    }
    
    func deleteAll(onComplete: @escaping (Error?, Bool?) -> Void) {
        self.notes.removeAll()
        onComplete(nil, true)
    }
}

class StorageViewControllerTest: XCTestCase {
    
    var storageVCToTest: StorageViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        storageVCToTest = mainStoryboard.instantiateViewController(withIdentifier: "StorageViewController") as! StorageViewController
        let testNote = Note()
        testNote.title = "test"
        testNote.content = "testContent"
        testNote.createdAt = Date()
        FakeStorageListener.noteId += 1
        testNote.id = FakeStorageListener.noteId
        storageVCToTest.storageListener = FakeStorageListener(withNotes: [testNote])
        UIApplication.shared.keyWindow!.rootViewController = storageVCToTest
        _ = storageVCToTest.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        storageVCToTest = nil
        super.tearDown()
    }
    
    func getWindowViewCount() -> Int {
        return UIApplication.shared.keyWindow!.subviews.count
    }
    
    func testRender() {
        XCTAssertEqual(storageVCToTest.notes.count, 1)
    }
    
    func testCreateModal() {
        let previousViewCount = self.getWindowViewCount()
        storageVCToTest.showCreateModal()
        let afterViewCount = self.getWindowViewCount()
        XCTAssertEqual(afterViewCount, previousViewCount + 1)
    }
    
    func testReadModal() {
        let previousViewCount = self.getWindowViewCount()
        storageVCToTest.showReadModal(identifier: 1)
        let afterViewCount = self.getWindowViewCount()
        XCTAssertEqual(afterViewCount, previousViewCount + 1)
    }
    
    func testEditModal() {
        let previousViewCount = self.getWindowViewCount()
        storageVCToTest.showEditModal(identifier: 1)
        let afterViewCount = self.getWindowViewCount()
        XCTAssertEqual(afterViewCount, previousViewCount + 1)
    }
    
    func testDeleteAllModal() {
        let previousViewCount = self.getWindowViewCount()
        storageVCToTest.showDeleteAllModal()
        let afterViewCount = self.getWindowViewCount()
        XCTAssertEqual(afterViewCount, previousViewCount + 1)
    }
    
    func testCreate() {
        let promise = expectation(description: "create")
        storageVCToTest.createNote(title: "test", content: "test")
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            promise.fulfill()
        }
        wait(for: [promise], timeout: 2)
        XCTAssertEqual(storageVCToTest.notes.count, 2)
    }
    
    func testEdit() {
        let promise = expectation(description: "edit")
        storageVCToTest.editNote(identifier: 1, title: "updated", content: "updated")
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            promise.fulfill()
        }
        wait(for: [promise], timeout: 2)
        XCTAssertEqual(storageVCToTest.notes.count, 1)
    }
    
    func testDelete() {
        let promise = expectation(description: "delete")
        storageVCToTest.deleteNote(title: "", identifier: FakeStorageListener.noteId)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            promise.fulfill()
        }
        wait(for: [promise], timeout: 2)
        XCTAssertEqual(storageVCToTest.notes.count, 0)
    }
    
    func testDeleteAll() {
        let promise = expectation(description: "delete all")
        storageVCToTest.deleteAllNotes()
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            promise.fulfill()
        }
        wait(for: [promise], timeout: 2)
        XCTAssertEqual(storageVCToTest.notes.count, 0)
    }
    
    func testRead() {
        let promise = expectation(description: "read")
        storageVCToTest.readNote(identifier: FakeStorageListener.noteId) { error, note in
            XCTAssertNotNil(note)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
        XCTAssertEqual(storageVCToTest.notes.count, 1)
    }
    
    
}
