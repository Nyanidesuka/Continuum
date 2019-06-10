//
//  Post.swift
//  Continuum
//
//  Created by Haley Jones on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class Post{
    
    struct ConstantKeys{
        static let typeKey = "Post"
        static let captionKey = "caption"
        static let timestampKey = "timestamp"
        static let commentsKey = "comments"
        static let imageKey = "image"
        static let imageAssetKey = "imageAsset"
    }
    
    var photoData: Data?
    let caption: String
    let timestamp: Date
    var comments: [Comment]
    var image: UIImage? {
        get{
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set{
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var postRecordID: CKRecord.ID
    var imageAsset: CKAsset?{
        get{
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print(error.localizedDescription)
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(photo: UIImage, caption: String, timeStamp: Date, comments: [Comment], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.caption = caption
        self.timestamp = Date()
        self.comments = comments
        self.postRecordID = recordID
        self.image = photo
    }
    
    convenience init?(record: CKRecord){
        guard let photoAsset = record[Post.ConstantKeys.imageAssetKey] as? CKAsset,
            let caption = record[Post.ConstantKeys.captionKey] as? String,
            let timestamp = record[Post.ConstantKeys.timestampKey] as? Date else {return nil}
        guard let imageData = try? Data(contentsOf: photoAsset.fileURL) else {return nil}
        self.init(photo: UIImage(data: imageData) ?? UIImage(), caption: caption, timeStamp: timestamp, comments: [], recordID: record.recordID)
    }
}

protocol SearchableRecord{
    func matchesSearchTerm(searchTerm: String) -> Bool
}

extension Post: SearchableRecord{
    func matchesSearchTerm(searchTerm: String) -> Bool {
        if self.caption.contains(searchTerm){
            return true
        }
        for comment in self.comments{
            if comment.text.contains(searchTerm){
                return true
            }
        }
        return false
    }
}

extension CKRecord{
    convenience init(post: Post){
        self.init(recordType: Post.ConstantKeys.typeKey, recordID:  post.postRecordID)
        setValue(post.caption, forKey: Post.ConstantKeys.captionKey)
        setValue(post.imageAsset, forKey: Post.ConstantKeys.imageAssetKey)
        setValue(post.timestamp, forKey: Post.ConstantKeys.timestampKey)
    }
}
