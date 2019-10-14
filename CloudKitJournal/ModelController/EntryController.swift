//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by Michael Di Cesare on 10/14/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    // MARK: - singleton
    static let shared = EntryController()
    let privateDB = CKContainer.default().privateCloudDatabase
    private init(){}
    // source of truth
    var entries: [Entry] = []

    // CRUD
    // save and add in same function 
    func saveEntry(title: String, bodyText: String, completion: @escaping (Bool) -> ()) {
        let newEntry = Entry(title: title, bodyText: bodyText)
        let record = CKRecord(entry: newEntry)
        privateDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = record,
                let saveEntry = Entry(ckRecord: record)
                else {completion(false); return }
            self.entries.append(saveEntry)
            completion(true)
        }
    }
    // MARK: - Fetch
    func fetchEntries(completion: @escaping (Bool) ->() ) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.RecordType, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let records = foundRecords else {
                completion(false)
                return
            }
            let entries = records.compactMap({Entry(ckRecord: $0) })
            self.entries = entries
            print("fetched successfully")
            completion(true)
        }
    }
}
