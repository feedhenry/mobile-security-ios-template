//
//  StorageViewController.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 20/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView
import Floaty
import RealmSwift

protocol StorageListener {
    func list(onComplete: @escaping (Error?, [Note]?) -> Void)
    func read(identifier: Int, onComplete: @escaping (Error?, Note?) -> Void)
    func create(title: String, content: String, onComplete: @escaping (Error?, Note?) -> Void)
    func edit(identifier: Int, title: String, content: String, onComplete: @escaping (Error?, Note?) -> Void)
    func delete(identifier: Int, onComplete: @escaping (Error?, Note?) -> Void)
    func deleteAll(onComplete: @escaping (Error?, Bool?) -> Void)
}

/* The class for the table view cells. */
class NoteTableViewCell: UITableViewCell {
    @IBOutlet var title: UILabel!
}

/* The view controller for the storage view. */
class StorageViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    var storageListener: StorageListener?
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.renderActionButton()
        self.loadNotes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     - Render the action button in the view with the create/delete all actions
     */
    func renderActionButton() {
        let floaty = Floaty(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        floaty.sticky = true
        floaty.buttonColor = UIColor.white
        
        // create note action handler
        floaty.addItem("New Note", icon: UIImage(named: "ic_note")!, handler: { item in
            self.showCreateModal()
            floaty.close()
        })
        
        // delete all notes handler
        floaty.addItem("Delete All", icon: UIImage(named: "ic_delete")!, handler: { item in
            if self.notes.isEmpty {
                self.showErrorAlert(title: "No Notes", message: "You don't have any Notes to delete!")
            } else {
                self.showDeleteAllModal()
            }
            floaty.close()
        })
        self.view.addSubview(floaty)
        
        // don't show empty table items
        self.tableView.tableFooterView = UIView()
    }
    
    /**
     - Display a modal to create a note
     */
    func showCreateModal() {
        
        // create the view
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        let title = alert.addTextField("Enter your Title")
        let content = alert.addTextView()
        
        // define the close action
        alert.addButton("Close") {
            let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showSuccess("", subTitle: "")
            alertViewResponder.close()
        }
        
        // define the create action
        alert.addButton("Create") {
            if (title.text?.isEmpty)! {
                self.showErrorAlert(title: "Error Creating Note", message: "Note Title Cannot Be Empty!")
            } else {
                self.createNote(title: title.text!, content: content.text!)
            }
        }
        
        // show the modal
        alert.showSuccess("Create Note", subTitle: "Create an Encrypted Note")
    }
    
    /**
     - Display a modal to edit a note
     
     - Parameter identifier: the identifier of the note to edit
     */
    func showEditModal(identifier: Int) {
        // get the note details
        self.readNote(identifier: identifier) {
            error, note in
            if(note != nil) {
        
                // create the view
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                
                let alert = SCLAlertView(appearance: appearance)
                
                // prefill the text fields with the current note title/content
                let title = alert.addTextField("Enter your Title")
                title.text = note?.title
                let content = alert.addTextView()
                content.text = note?.content
                
                // define the close action
                alert.addButton("Close") {
                    let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showEdit("", subTitle: "")
                    alertViewResponder.close()
                }
                
                // define the create action
                alert.addButton("Update") {
                    self.editNote(identifier: identifier, title: title.text!, content: content.text!)
                }
                
                // show the modal
                alert.showEdit("Update Note", subTitle: "Update an Encrypted Note")
            } else {
                 self.showErrorAlert(title: "Unable to Read Note", message: "\(error?.localizedDescription ?? "Realm Read Error")")
            }
        }
    }
    
    /**
     - Display a modal to show the note details
     
     - Parameter identifier: the identifier of the note to show
     */
    func showReadModal(identifier: Int) {
        // get the note details
        self.readNote(identifier: identifier) {
            error, note in
            if(note != nil) {
                
                // create the view
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance)
                
                // define the close action
                alert.addButton("Close") {
                    let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showInfo("", subTitle: "")
                    alertViewResponder.close()
                }
                
                // show the modal
                alert.showInfo((note?.title)!, subTitle: (note?.content)!)
            } else {
                self.showErrorAlert(title: "Unable to Read Note", message: "\(error?.localizedDescription ?? "Realm Read Error")")
            }
        }
    }
    
    /**
     - Display a modal to delete all notes
    */
    func showDeleteAllModal() {
        
        // create the view
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        
        // define the close action
        alert.addButton("Close") {
            let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showWarning("", subTitle: "")
            alertViewResponder.close()
        }
        
        // define the delete all action
        alert.addButton("Confirm Delete") {
            self.deleteAllNotes()
        }
        
        // show the modal
        alert.showWarning("Delete All Notes?", subTitle: "Are you sure?")
    }
    
    /**
     - Function to load/re-load notes to display in the UI
     */
    func loadNotes() {
        self.storageListener?.list() {
            error, notes in
            if(notes != nil) {
                self.notes = notes!
                self.tableView.reloadData()
            } else {
                self.showErrorAlert(title: "Unable to Retrieve Notes", message: "\(error?.localizedDescription ?? "Realm Read Error")")
            }
        }
    }
    
    /**
     - Get a note from the storage service
     
     - Parameter identifier: the identifier of the note to get
     */
    func readNote(identifier: Int, onComplete: @escaping (Error?, Note?) -> Void) {
        self.storageListener?.read(identifier: identifier) {
            error, note in
            if(note != nil) {
                onComplete(nil, note!)
            } else {
                onComplete(error, nil)
            }
        }
    }
    
    /**
     - Create a note using the storage service
     
     - Parameter title: the title of the note
     - Parameter content: the content of the note
     */
    func createNote(title: String, content: String) {
        self.storageListener?.create(title: title, content: content) {
            error, note in
            DispatchQueue.main.async() {
                if(note != nil) {
                    self.loadNotes()
                } else {
                    self.showErrorAlert(title: "Unable to Create Note", message: "\(error?.localizedDescription ?? "Realm Create Error")")
                }
            }
        }
    }
    
    /**
     - Edit a note using the storage service
     
     - Parameter identifier: the identifier of the note to get
     - Parameter title: the title of the note
     - Parameter content: the content of the note
     */
    func editNote(identifier: Int, title: String, content: String) {
        self.storageListener?.edit(identifier: identifier, title: title, content: content) {
            error, note in
            DispatchQueue.main.async() {
                if(note != nil) {
                    self.loadNotes()
                } else {
                    self.showErrorAlert(title: "Unable to Update Note", message: "\(error?.localizedDescription ?? "Realm Update Error")")
                }
            }
        }
    }
    
    /**
     - Delete a note using the storage service
     
     - Parameter identifier: the identifier of the note to delete
     */
    func deleteNote(title: String, identifier: Int) {

        self.storageListener?.delete(identifier: identifier) {
            error, note in
            DispatchQueue.main.async() {
                if(note != nil) {
                    self.loadNotes()
                } else {
                    self.showErrorAlert(title: "Unable to Delete Note", message: "\(error?.localizedDescription ?? "Realm Delete Error")")
                }
            }
        }
    }
    
    /**
     - Delete all notes using the storage service
     */
    func deleteAllNotes() {
        self.storageListener?.deleteAll() {
            error, success in
            DispatchQueue.main.async() {
                if(success == true) {
                    self.loadNotes()
                    self.showSuccessAlert(title: "Success", message: "Notes Succesfully Deleted")
                } else {
                    self.showErrorAlert(title: "Unable to Delete Notes", message: "\(error?.localizedDescription ?? "Realm Delete Error")")
                }
            }
        }
    }
    
    /**
     - Set the number of sections required in the table
     
     - Returns: The number of sections
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    /**
     - Set the number of rows required in the section
     
     - Returns: The number of notes
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    /**
     - Setup of the table view to reference the table in the storyboard
     
     - Returns: An individual cell in the table list
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NoteTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NoteTableViewCell
        
        // Fetches the appropriate note for the data source layout.
        let note = self.notes[indexPath.row]
        
        // set the properties for the cell
        cell.textLabel?.text = note.title
        
        return cell
    }
    
    /**
     - Handler for selections on the table cells
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteIdentifier = self.notes[indexPath.row].id
        self.showReadModal(identifier: noteIdentifier)
    }
    
    /**
     - Define the edit and delete buttons with actions when tapped
     */
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let noteIdentifier = self.notes[index.row].id
            let noteTitle = self.notes[index.row].title
            self.deleteNote(title: noteTitle, identifier: noteIdentifier)
        }
        delete.backgroundColor = .red
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            let noteIdentifier = self.notes[index.row].id
            self.showEditModal(identifier: noteIdentifier)
        }
        edit.backgroundColor = .purple
        
        return [delete, edit]
    }
    
    /**
     - Show a success alert with a given title and message
     
     - Parameter title: the title of the alert
     - Parameter message: the message of the alert
     */
    func showSuccessAlert(title: String, message: String) {
        SCLAlertView().showSuccess(title, subTitle: message)
    }
    
    
    /**
     - Show an info alert with a given title and message
     
     - Parameter title: the title of the alert
     - Parameter message: the message of the alert
     */
    func showInfoAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
    }
    
    
    /**
     - Show an error alert with a given title and message
     
     - Parameter title: the title of the alert
     - Parameter message: the message of the alert
     */
    func showErrorAlert(title: String, message: String) {
        SCLAlertView().showError(title, subTitle: message)
    }
    
}
