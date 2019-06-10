//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Haley Jones on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {

    var isSearching = false
    var resultsArray: [Post] = []
    var dataSource: [Post]{
        if isSearching{
            return resultsArray
        } else {
            return PostController.shared.posts
        }
    }
    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullSync { (_) in
            DispatchQueue.main.async {
                print("done fetching")
                self.tableView.reloadData()
            }
        }
        searchBar.delegate = self
    }
    
    func fullSync(completion: @escaping ([Post]?) -> Void){
        print("starting fetch")
        PostController.shared.fetchPosts { (posts) in
            guard let posts = posts else {print("couldnt unrwrap"); return}
            PostController.shared.posts = posts
            print("starting comment fetches")
            for post in posts{
                print("trying to fetch some comments...")
                PostController.shared.fetchComments(forPost: post, completion: { (_) in
                    print("got a comment")
                })
            }
            completion(posts)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resultsArray = PostController.shared.posts
        tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
        
        
        let post = dataSource[indexPath.row]
        cell.postImageView.image = post.image
        cell.postCaptionLabel.text = post.caption
        cell.postCommentsLabel.text = "Comments: \(post.comments.count)"

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetail"{
            guard let destinVC = segue.destination as? PostDetailTableViewController else {return}
            guard let index = tableView.indexPathForSelectedRow else {return}
            
            let passPost = dataSource[index.row]
            destinVC.post = passPost
            
        }
    }
}

extension PostListTableViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, searchTerm != "" else {return}
        resultsArray = []
        for post in PostController.shared.posts{
            if post.matchesSearchTerm(searchTerm: searchTerm){
                resultsArray.append(post)
            }
        }
        isSearching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        resultsArray = PostController.shared.posts
        tableView.reloadData()
    }
}
