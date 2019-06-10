//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Haley Jones on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class PostDetailTableViewController: UITableViewController {
    
    var post: Post?{
        didSet{
            updateViews()
        }
    }

    //outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //IBActions
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        let commentAlert = UIAlertController(title: "Add Comment", message: nil, preferredStyle: .alert)
        commentAlert.addTextField { (commentField) in
            commentField.placeholder = "enter comment"
        }
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let postText = commentAlert.textFields?[0].text, postText != "" else {return}
            guard let pagePost = self.post else {return} //return if the detail view doesnt have a post.
            let newComment = Comment(text: postText, post: pagePost)
            pagePost.comments.append(newComment)
            let commentRecord = CKRecord(comment: newComment)
            PostController.shared.publicDB.save(commentRecord, completionHandler: { (record, error) in
                if let error = error{
                    print("there was an error saving the comment. \(error.localizedDescription)")
                }
            })
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (cancel) in
            commentAlert.textFields?[0].text = ""
        }
        commentAlert.addAction(postAction)
        commentAlert.addAction(cancelAction)
        self.present(commentAlert, animated: true) //this line shows the alert we just built.
    }
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        //unwrap a new image an caption variable just to make it easier to work with
        guard let image = post?.image, let caption = post?.caption else {return}
        //we make a new view controller, which is a UIActivityViewController.
        //Those are the kind you see when you hit share on twitter, or other similar things. Lets you forward, save images, etc.
        //we have to expose items from this VC to the new one so it can share them. We expose the post's image and caption.
        //The activties is left nil. I dont understand that part yet, but it works so far.
        let activityVC = UIActivityViewController(activityItems: [image, caption], applicationActivities: [])
        //then we show it.
        self.present(activityVC, animated: true) {
            //stuff
        }
    }
    @IBAction func followButtonTapped(_ sender: UIButton) {
        
    }
    
    func updateViews(){
        DispatchQueue.main.async {
            guard let post = self.post else {print("missing thing"); return}
            self.postImageView.image = post.image
            self.captionLabel.text = "Caption: \(post.caption)"
            self.tableView.reloadData()
        }
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return post?.comments.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        guard let post = post else {return cell}
        let comment = post.comments[indexPath.row]
        cell.textLabel?.text = comment.text
        cell.detailTextLabel?.text = DateFormatter.localizedString(from: comment.timestamp, dateStyle: .short, timeStyle: .short)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
