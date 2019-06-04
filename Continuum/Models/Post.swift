//
//  Post.swift
//  Continuum
//
//  Created by Haley Jones on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import UIKit

class Post{
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
    
    init(photo: UIImage, caption: String, timeStamp: Date, comments: [Comment]){
        self.caption = caption
        self.timestamp = Date()
        self.comments = comments
        self.image = photo
    }
}
