//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Haley Jones on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var postCommentsLabel: UILabel!
    
    var post: Post?{
        didSet{
            updateViews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews(){
        DispatchQueue.main.async {
            if let post = self.post{
                self.postCaptionLabel.text = post.caption
                self.postCommentsLabel.text = "Comments: \(post.comments.count)"
                if let image = post.image{
                    self.postImageView.image = image
                }
            }
        }
    }
}
