//
//  NoteViewController.swift
//  MyCustomNotes
//
//  Created by Филипп Степанов on 13.09.2022.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {

    var note: Note?
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = note?.text
        title = note?.title
        
        textView.delegate = self
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        note?.setNewText(newText: textView.text)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let note = note else { return }
        if textView.text == "" {
            CoreDataManager.defaultManager.deleteNote(note: note)
        }
    }

}
