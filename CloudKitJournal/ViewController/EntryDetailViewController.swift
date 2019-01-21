//
//  EntryDetailViewController.swift
//  CloudKitJournal
//
//  Created by DevMountain on 1/18/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
  
  //MARK: - IBOUTLETS
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var bodyTextView: UITextView!
  
  //MARK: - Properties
  var entry: Entry?
  
  //MARK: - View Life Cycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  //MARK: - Functions
  func updateViews(){
    guard let entry = entry else { return }
    titleTextField.text = entry.title
    bodyTextView.text = entry.body
  }
  
  //MARK: - IBActions
  @IBAction func clearButtonTapped(_ sender: Any) {
    titleTextField.text = ""
    bodyTextView.text = ""
  }
  
  @IBAction func mainViewTapped(_ sender: Any) {
    bodyTextView.resignFirstResponder()
    titleTextField.resignFirstResponder()
  }
}

//MARK: - UITextFieldDelegate
extension EntryDetailViewController: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
