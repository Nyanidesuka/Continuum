//
//  PostController.swift
//  Continuum
//
//  Created by Haley Jones on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import UIKit

class PostController{
    
    //singleton
    static let shared = PostController()
    //Source of Truth
    var posts: [Post] = []
    
    //CRUD
    func addComment(text: String, post: Post, completion: @escaping (Comment) -> Void){
        let newComment = Comment(text: text, post: post)
        post.comments.append(newComment)
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> Void){
        let newPost = Post(photo: image, caption: caption, timeStamp: Date(), comments: [])
        PostController.shared.posts.append(newPost)
    }
    
}
