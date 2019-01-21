//
//  EntryListTableViewController.swift
//  CloudKitJournal
//
//  Created by DevMountain on 1/18/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {
  
  //MARK: - View Life Cycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    EntryController.shared.fetchEntries { (success) in
      if success{
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return EntryController.shared.entries.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
    let entry = EntryController.shared.entries[indexPath.row]
    cell.textLabel?.text = entry.title
    return cell
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toEditEntry"{
      let destinationVC = segue.destination as? EntryDetailViewController
      guard let indexPath = tableView.indexPathForSelectedRow else { return }
      let entry = EntryController.shared.entries[indexPath.row]
      destinationVC?.entry = entry
    }
  }
}
