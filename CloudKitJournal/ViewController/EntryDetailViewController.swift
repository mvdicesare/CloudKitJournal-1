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
  var entry: Entry?{
    didSet{
      loadViewIfNeeded()
      updateViews()
    }
  }
  
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
  
  func saveNewEntry(completion: @escaping (Bool) -> Void){
    guard let title = titleTextField.text,
      !title.isEmpty,
      !bodyTextView.text.isEmpty else { presentErrorAlert() ; return }
    EntryController.shared.addEntryWith(title: title, body: bodyTextView.text, completion: completion)
  }
  
  func updateEntry(completion: @escaping (Bool) -> Void){
    guard let entry = entry,
      let title = titleTextField.text,
      !title.isEmpty,
      !bodyTextView.text.isEmpty else { presentErrorAlert() ; return }
    EntryController.shared.update(entry: entry, newTitle: title, newBody: bodyTextView.text, completion: completion)
  }
  
  func presentErrorAlert(){
    let alertController = UIAlertController(title: "Whoops", message: "Something went wrong saving that entry ):", preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
    alertController.addAction(confirmAction)
    self.present(alertController, animated: true)
  }
  
  func respondToSave(success: Bool){
    DispatchQueue.main.async {
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      if success{
        self.navigationController?.popViewController(animated: true)
      }else {
        self.presentErrorAlert()
      }
    }
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
  
  @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    entry == nil ? saveNewEntry(completion: respondToSave(success:)) : updateEntry(completion: respondToSave(success:))
  }
}

//MARK: - UITextFieldDelegate
extension EntryDetailViewController: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
