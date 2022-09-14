//
//  CoreDataManager.swift
//  MyCustomNotes
//
//  Created by Филипп Степанов on 13.09.2022.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let defaultManager = CoreDataManager()
    
    init() {
        reloadNotes()
        reloadFolders()
    }
    
    var notes: [Note] = []
    
    var folders: [Folder] = []
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyCustomNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Note's methods

extension CoreDataManager {
    
    func addNote(in folder: Folder?) -> Note {
        let newNote = Note(context: persistentContainer.viewContext)
        newNote.created_at = Date()
        newNote.updated_at = Date()
        newNote.text = ""
        newNote.folder = folder
        folder?.updated_at = Date()
        saveContext()
        reloadNotes()
        return newNote
    }
    
    func deleteNote(note: Note) {
        persistentContainer.viewContext.delete(note)
        saveContext()
        reloadNotes()
    }
    
    private func reloadNotes() {
        let request = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "updated_at", ascending: false)]
        do {
            let notes = try persistentContainer.viewContext.fetch(request)
            self.notes = notes
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Folder's methods

extension CoreDataManager {
    
    func addFolder(name: String) {
        let newFolder = Folder(context: persistentContainer.viewContext)
        newFolder.created_at = Date()
        newFolder.updated_at = Date()
        newFolder.name = name
        saveContext()
        reloadFolders()
    }
    
    func deleteFolder(folder: Folder) {
        persistentContainer.viewContext.delete(folder)
        saveContext()
        reloadFolders()
    }
    
    func renameFolder(newName: String) {
        
    }
    
    private func reloadFolders() {
        let request = Folder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let folders = try persistentContainer.viewContext.fetch(request)
            self.folders = folders
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
