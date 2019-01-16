//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by DevMountain on 1/15/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import CloudKit

class EntryController{
  
  //MARK: - Shared Instance
  static let shared = EntryController()
  private init() {}
  
  //MARK: - Source of Truth
  var entries: [Entry] = []
  
  //MARK: - CRUD Functions
  func save(entry: Entry, completion: @escaping (Bool) -> ()){
    let record = CKRecord(entry: entry)
    CKContainer.default().privateCloudDatabase.save(record) { (record, error) in
      if let error = error{
        print("\(error.localizedDescription) \(error) in function: \(#function)")
        completion(false)
        return
      }
      guard let record = record,
            let entry = Entry(ckRecord: record) else { completion(false) ; return }
      self.entries.append(entry)
      completion(true)
    }
  }
  
  func addEntryWith(title: String, body: String, completion: @escaping (Bool) -> Void){
    let entry = Entry(title: title, body: body)
    save(entry: entry, completion: completion)
  }
  
  func fetchEntries(completion: @escaping (Bool) -> Void){
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: EntryContstants.RecordType, predicate: predicate)
    CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
      if let error = error{
        print("\(error.localizedDescription) \(error) in function: \(#function)")
        completion(false)
        return
      }
      guard let records = records else { completion(false) ; return }
      let entries = records.compactMap{ Entry(ckRecord: $0) }
      self.entries = entries
      completion(true)
    }
  }
  
  private func deleteLocal(_ entry: Entry){
    guard let index = entries.index(of: entry) else { return }
    entries.remove(at: index)
  }
  
  private func deleteFromCloudKit(_ entry: Entry, completion: ((Entry?) -> Void)?){
    let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [entry.ckRecordID])
    operation.queuePriority = .high
    operation.qualityOfService = .userInitiated
    operation.modifyRecordsCompletionBlock = {(_, _, error: Error?) in
      if let error = error{
        print("\(error.localizedDescription) \(error) in function: \(#function)")
        completion?(nil)
        return
      }
      completion?(entry)
    }
    CKContainer.default().add(operation)
  }
  
  func delete(_ entry: Entry, completion: ((Entry?) -> Void)?){
    deleteLocal(entry)
    deleteFromCloudKit(entry, completion: completion)
  }
}
