//
//  Comment.swift
//  Continuum
//
//  Created by Haley Jones on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import CloudKit

class Comment{
    
    struct ConstantKeys{
        static let typeKey = "comment"
        static let postKey = "postReference"
        static let textKey = "text"
        static let timestampKey = "timestamp"
    }
    
    let text: String
    let timestamp: Date
    weak var post: Post?
    var postReference: CKRecord.Reference?{
        guard let post = post else {return nil}
        return CKRecord.Reference(recordID: post.postRecordID, action: .deleteSelf)
    }
    let recordID: CKRecord.ID
    init(text: String, timestamp: Date = Date(), post: Post, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.text = text
        self.timestamp = timestamp
        self.post = post
        self.recordID = recordID
    }
    
    convenience init?(record: CKRecord, post: Post){
        guard let text = record[Comment.ConstantKeys.textKey] as? String,
        let timestamp = record[Comment.ConstantKeys.timestampKey] as? Date,
            let postReference = record[Comment.ConstantKeys.postKey] as? CKRecord.Reference else {return nil}
        self.init(text: text, timestamp: timestamp, post: post, recordID: record.recordID)
    }
}


extension CKRecord{
    convenience init(comment: Comment){
        self.init(recordType: Comment.ConstantKeys.typeKey, recordID: comment.recordID)
        setValue(comment.postReference , forKey: Comment.ConstantKeys.postKey)
        setValue(comment.text, forKey: Comment.ConstantKeys.textKey)
        setValue(comment.timestamp, forKey: Comment.ConstantKeys.timestampKey)
    }
}
