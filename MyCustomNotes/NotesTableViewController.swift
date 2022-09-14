//
//  NotesTableViewController.swift
//  MyCustomNotes
//
//  Created by Филипп Степанов on 13.09.2022.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    var folder: Folder?
    
    var notes: [Note] {
        if let folder = folder {
            return folder.notesSorted
        } else {
            return CoreDataManager.defaultManager.notes
        }
    }
    
    var selectNote: Note?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let folder = folder {
            title = folder.name
        } else {
            title = "Notes"
        }
    }
    
    @IBAction func addNoteAction(_ sender: Any) {
        selectNote = CoreDataManager.defaultManager.addNote(in: folder)
        performSegue(withIdentifier: "goToNoteController", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.updateDateFormatter

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectNote = notes[indexPath.row]
        performSegue(withIdentifier: "goToNoteController", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let manager = CoreDataManager.defaultManager
            manager.deleteNote(note: notes[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? NoteViewController)?.note = selectNote
    }
    

}
