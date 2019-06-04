//
//  Comment.swift
//  Continuum
//
//  Created by Haley Jones on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

class Comment{
    let text: String
    let timestamp: Date
    weak var post: Post?
    init(text: String, timestamp: Date = Date(), post: Post){
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
}
