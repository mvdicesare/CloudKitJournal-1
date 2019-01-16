//
//  Entry.swift
//  CloudKitJournal
//
//  Created by DevMountain on 1/15/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import CloudKit

class Entry{
  
  //MARK: - Properties
  var title: String
  var body: String
  let timestamp: Date
  let ckRecordID: CKRecord.ID
  
  //MARK: - Initializers
  init(title: String, body: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
    self.title = title
    self.body = body
    self.timestamp = timestamp
    self.ckRecordID = ckRecordID
  }
  
  convenience init?(ckRecord: CKRecord){
    guard let title = ckRecord[EntryContstants.TitleKey] as? String,
      let body = ckRecord[EntryContstants.BodyKey] as? String,
      let timestamp = ckRecord[EntryContstants.TimestampKey] as? Date else { return nil }
    
    self.init(title: title, body: body, timestamp: timestamp, ckRecordID: ckRecord.recordID)
  }
}

//MARK: - Equatable
extension Entry: Equatable{
  static func == (lhs: Entry, rhs: Entry) -> Bool {
    return lhs.title == rhs.title && lhs.body == rhs.body && lhs.timestamp == rhs.timestamp
  }
}

//MARK: - CKRecord Entry Convenience Initializer
extension CKRecord{
  convenience init(entry: Entry){
    self.init(recordType: EntryContstants.RecordType, recordID: entry.ckRecordID)
    self.setValue(entry.title, forKey: EntryContstants.TitleKey)
    self.setValue(entry.body, forKey: EntryContstants.BodyKey)
    self.setValue(entry.timestamp, forKey: EntryContstants.TimestampKey)
  }
}

//MARK: - Entry Constants
struct EntryContstants{
  static let TitleKey = "title"
  static let BodyKey = "body"
  static let TimestampKey = "timestamp"
  static let RecordType = "Entry"
}
