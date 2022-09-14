//
//  Note.swift
//  MyCustomNotes
//
//  Created by Филипп Степанов on 13.09.2022.
//

import Foundation
import CoreData

extension Note {
    
    var title: String {
        return text?.components(separatedBy: " ").first ?? "Новая заметка"
    }
    
    var updateDateFormatter: String {
        let dt = DateFormatter()
        dt.dateStyle = .medium
        dt.timeStyle = .medium
        return dt.string(from: updated_at ?? Date())
    }
    
    func setNewText(newText: String) {
        text = newText
        updated_at = Date()
        folder?.updated_at = Date() 
        do {
            try self.managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
