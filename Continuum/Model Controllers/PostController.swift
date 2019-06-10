//
//  PostController.swift
//  Continuum
//
//  Created by Haley Jones on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class PostController{
    
    //singleton
    static let shared = PostController()
    //Source of Truth
    var posts: [Post] = []
    //database
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //CRUD
    func addComment(text: String, post: Post, completion: @escaping (Comment) -> Void){
        let newComment = Comment(text: text, post: post)
        post.comments.append(newComment)
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> Void){
        let newPost = Post(photo: image, caption: caption, timeStamp: Date(), comments: [])
        let postRecord = CKRecord(post: newPost)
        publicDB.save(postRecord) { (record, error) in
            if let error = error{
                print("There ws an error saving a new post. \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(newPost)
            PostController.shared.posts.append(newPost)
        }
    }
    
    func fetchPosts(completion: @escaping ([Post]?) -> Void){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Post.ConstantKeys.typeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error{
                print("there was an error fetching posts. \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let posts = records?.compactMap({return Post(record: $0)}) else {completion(nil); return}
            PostController.shared.posts = posts
            completion(posts)
            
        }
    }
    
    func fetchComments(forPost post: Post, completion: @escaping ([Comment]?) -> Void){
        let postRefence = post.postRecordID
        let predicate = NSPredicate(format: "%K == %@", Comment.ConstantKeys.postKey, postRefence)
        let commentIDs = post.comments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: "Comment", predicate: compoundPredicate)
        PostController.shared.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error{
                print("there was an error fetching comments. \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let comments = records?.compactMap({return Comment(record: $0, post: post)}) else {completion(nil); return}
            post.comments = comments
            print("completing with comments: \(comments.count)")
            completion(comments)
        }
    }
    
    func subscribeToNewPosts(completion: @escaping (Bool) -> Void){
        let predicate = NSPredicate(value: true)
        let subscribey = CKQuerySubscription(recordType: Post.ConstantKeys.typeKey, predicate: predicate)
        publicDB.save(subscribey) { (subscription, error) in
            if let error = error{
                print("there was an error in \(#function); \(error.localizedDescription)")
                completion(false)
                return
            }
        }
    }
    
    func addCommentSubscription(forPost post: Post, completion: @escaping (Bool) -> Void){
        let predicate = NSPredicate(format: "recordID == %@", post.postRecordID)
        let subscription = CKQuerySubscription(recordType: Comment.ConstantKeys.typeKey, predicate: predicate)
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = "A new comment was posted."
        notificationInfo.shouldSendContentAvailable = false
        subscription.notificationInfo = notificationInfo
        publicDB.save(subscription) { (sub, error) in
            if let error = error{
                print("there was an error in \(#function); \(error.localizedDescription)")
                completion(false)
                return
            }
        }
    }
}
