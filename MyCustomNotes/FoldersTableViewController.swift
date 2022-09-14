//
//  FoldersTableViewController.swift
//  MyCustomNotes
//
//  Created by Филипп Степанов on 13.09.2022.
//

import UIKit

class FoldersTableViewController: UITableViewController {
    
    var folder: Folder?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        tableView.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        let folder = CoreDataManager.defaultManager.folders[indexPath.row]
        let alertVC = UIAlertController(title: "Введите название папки", message: "", preferredStyle: .alert)
        alertVC.addTextField { textfield in
            textfield.placeholder = "Введите новое название папки"
            textfield.text = folder.name
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { alert in
            guard let name = alertVC.textFields?[0].text, name != "" else { return }
            folder.changeName(newName: name.capitalized(with: nil))
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }
    
    @IBAction func addFolderAction() {
        let alertVC = UIAlertController(title: "Введите название папки", message: "", preferredStyle: .alert)
        alertVC.addTextField { textfield in
            textfield.placeholder = "Введите название папки"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { alert in
            guard let name = alertVC.textFields?[0].text, name != "" else { return }
            CoreDataManager.defaultManager.addFolder(name: name)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.defaultManager.folders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath)

        let folder = CoreDataManager.defaultManager.folders[indexPath.row]
        
        cell.textLabel?.text = folder.name
        cell.detailTextLabel?.text = "\(folder.notes?.count ?? 0) notes"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.folder = CoreDataManager.defaultManager.folders[indexPath.row]
        performSegue(withIdentifier: "goToNotes", sender: self)
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
            manager.deleteFolder(folder: manager.folders[indexPath.row])
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? NotesTableViewController)?.folder = folder
    }
    

}
