//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by Lawrence Chong on 2/28/16.
//  Copyright © 2016 Lawrence Chong. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogOutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print("error: \(error.localizedDescription)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterCell", forIndexPath: indexPath) as! TwitterCell
        cell.tweet = tweets[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            print(tweets!.count)
            return tweets!.count
        } else {
            return 0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        navigationItem.backBarButtonItem = backItem
        
        let seg = segue.identifier
        
        if seg == "TwitterCell" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets[indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.tweet = tweet
        } else if seg == "NewPost"{
            
            
        } else if seg == "ProfileView" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets[indexPath!.row]
            
            let user = tweet.user
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.clicked_user = user
        }
        
    }
    
    
}
