//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Haley Jones on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import AVKit

class AddPostTableViewController: UITableViewController {

    @IBOutlet weak var captionTextField: UITextView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: IBActions
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        guard let postImage = image else {return}
        guard let postText = captionTextField.text, postText != "" else {return}
        PostController.shared.createPostWith(image: postImage, caption: postText) { (post) in
            PostController.shared.posts.append(post!)
        }
        self.tabBarController?.selectedIndex = 0
    }
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        image = nil
        captionTextField.text = ""
        self.tabBarController?.selectedIndex = 0
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerSegue"{
            guard let destinVC = segue.destination as? PhotoSelectorViewController else {return}
            destinVC.delegate = self
        }
    }
}

extension AddPostTableViewController: PhotoSelectorViewControllerDelegate{
    func photoSelectorViewControllerSelected(image: UIImage) {
        self.image = image
    }
}


