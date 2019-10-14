//
//  EntryTableViewController.swift
//  CloudKitJournal
//
//  Created by Michael Di Cesare on 10/14/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit



//addNewEntry
//cellToEntry
class EntryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EntryController.shared.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entriyCell", for: indexPath)
        let entry = EntryController.shared.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        return cell
    }
    

    

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToEntry" {
            let destinationVC = segue.destination as? EntryViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let entry = EntryController.shared.entries[indexPath.row]
            destinationVC?.entry = entry
        }
    }
}
