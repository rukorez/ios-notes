//
//  Folder.swift
//  MyCustomNotes
//
//  Created by Филипп Степанов on 13.09.2022.
//

import Foundation
import CoreData

extension Folder {
    
    var notesSorted: [Note] {
        (notes?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)])) as? [Note] ?? []
    }
    
    var updateDateFormatter: String {
        let dt = DateFormatter()
        dt.dateStyle = .medium
        dt.timeStyle = .medium
        return dt.string(from: updated_at ?? Date())
    }
    
    func changeName(newName: String) {
        name = newName
        do {
            try managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updatedAt() {
        updated_at = Date()
        do {
            try managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
