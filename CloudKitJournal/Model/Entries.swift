//
//  Entries.swift
//  CloudKitJournal
//
//  Created by Michael Di Cesare on 10/14/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import CloudKit
// MARK: - Constants
struct EntryConstants {
    static let TitleKey = "title"
    static let BodyKey = "body"
    static let TimestampKey = "timestamp"
    static let RecordType = "Entry"
}



// MARK: - Class Declaration
class Entry {
    var title: String
    var bodyText: String
    var timestamp: Date
    var ckRecordID: CKRecord.ID
    
    init(title: String, bodyText: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}
// MARK: - Convienience init Extention
extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryConstants.TitleKey] as? String,
            let bodyText = ckRecord[EntryConstants.BodyKey] as? String,
            let timestamp = ckRecord[EntryConstants.TimestampKey] as? Date else {return nil}
        self.init(title: title, bodyText: bodyText, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}
extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.RecordType, recordID: entry.ckRecordID)
        self.setValue(entry.title, forKey: EntryConstants.TitleKey)
        self.setValue(entry.bodyText, forKey: EntryConstants.BodyKey)
        self.setValue(entry.timestamp, forKey: EntryConstants.TimestampKey)
        
    }
}





