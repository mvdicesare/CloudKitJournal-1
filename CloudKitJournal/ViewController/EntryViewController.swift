//
//  EntryViewController.swift
//  CloudKitJournal
//
//  Created by Michael Di Cesare on 10/14/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    // MARK: -  Outlets
    
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var entryBodyTitle: UITextView!
    // landing pad
    var entry: Entry?{
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        entryBodyTitle.layer.borderColor = UIColor.lightGray.cgColor
        entryBodyTitle.layer.borderWidth = 0.25
        entryBodyTitle.layer.cornerRadius = 8.0
        entryBodyTitle.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        entryBodyTitle.layer.cornerRadius = 10
    }
    
    
    // MARK: - Actions

    
    @IBAction func clearButtonPressed(_ sender: Any) {
        entryTitle.text = ""
        entryBodyTitle.text = ""
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let title = entryTitle.text,
            !title.isEmpty,
            entryBodyTitle.text.isEmpty else {return}
        EntryController.shared.saveEntry(title: title, bodyText: entryBodyTitle.text) { (true) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func tapGesturePressed(_ sender: Any) {
        entryTitle.resignFirstResponder()
        entryBodyTitle.resignFirstResponder()
    }

    // MARK: - Functions
    func updateViews() {
        entryTitle.text = entry?.title
        entryBodyTitle.text = entry?.bodyText
    }
}


extension EntryViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
