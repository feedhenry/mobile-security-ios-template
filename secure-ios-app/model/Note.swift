//
//  Note.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 20/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import RealmSwift

class Note: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var storageProvider: String = ""
    
    func clone() -> Note {
        let another = Note()
        another.id = self.id
        another.title = self.title
        another.content = self.content
        another.createdAt = self.createdAt
        another.storageProvider = self.storageProvider
        return another
    }
}
