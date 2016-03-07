 //
 //  DetailViewController.swift
 //  TwitterApp
 //
 //  Created by Lawrence Chong on 3/6/16.
 //  Copyright © 2016 Lawrence Chong. All rights reserved.
 //
 
 import UIKit
 
 class DetailViewController: UIViewController {
    
    var tweet: Tweet!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var numberofretweetsLabel: UILabel!
    
    @IBOutlet weak var numberoflikesLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = tweet.user?.name as? String
        tweetLabel.text = tweet.text as? String
        screennameLabel.text = "@" + (tweet.user?.screenname as? String)!
        numberofretweetsLabel.text = String(tweet.retweet)
        numberoflikesLabel.text = String(tweet.favorites_count)
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        let dateString = formatter.stringFromDate(tweet.timestamp!)
        
        timeLabel.text = dateString
        
        if tweet.user?.profile_url != nil {
            profileImageView.setImageWithURL((tweet.user?.profile_url)!)
        }
        
        replyButton.setTitle(nil, forState: UIControlState.Normal)
        likeButton.setTitle(nil, forState: UIControlState.Normal)
        retweetButton.setTitle(nil, forState: UIControlState.Normal)
        
        replyButton.setImage(UIImage(named: "reply.png"), forState: UIControlState.Normal)
        
        if tweet.retweeted == true {
            retweetButton.setImage(UIImage(named: "retweeted.png"), forState: UIControlState.Normal)
            retweetButton.tintColor = UIColor.greenColor()
        } else{
            retweetButton.setImage(UIImage(named: "retweet.png"), forState: UIControlState.Normal)
            retweetButton.tintColor = UIColor.blueColor()
        }
        
        if tweet.favorited == true {
            likeButton.setImage(UIImage(named: "star_filled.png"), forState: UIControlState.Normal)
            likeButton.tintColor = UIColor.yellowColor()
        } else{
            likeButton.setImage(UIImage(named: "star_unfilled.png"), forState: UIControlState.Normal)
            likeButton.tintColor = UIColor.blueColor()
        }
        
    }
    
    @IBAction func onReplyButton(sender: AnyObject) {
        
    }
    
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        if tweet.retweeted == false { //retweet it!
            TwitterClient.sharedInstance.retweet(tweet.id! as String, completion: { (tweet: Tweet?, error: NSError?) -> () in
                if tweet != nil {
                    self.numberofretweetsLabel.text = String(tweet!.retweet)
                    self.retweetButton.setImage(UIImage(named: "retweeted.png"), forState: UIControlState.Normal)
                    self.retweetButton.tintColor = UIColor.greenColor()
                }
            })
        } else { //unretweet it
            TwitterClient.sharedInstance.unretweet(tweet.id! as String, completion: { (tweet: Tweet?, error: NSError?) -> () in
                if tweet != nil {
                    self.numberofretweetsLabel.text = String(tweet!.retweet)
                    self.retweetButton.setImage(UIImage(named: "retweet.png"), forState: UIControlState.Normal)
                    self.retweetButton.tintColor = UIColor.blueColor()
                    
                }            })
        }
    }
    
    
    @IBAction func onFavoriteButton(sender: AnyObject) {
        if tweet.favorited == false { //like it
            TwitterClient.sharedInstance.favorite(["id" : tweet.id!], completion: { (tweet: Tweet?, error: NSError?) -> () in
                if tweet != nil {
                    self.numberoflikesLabel.text = String(tweet!.favorites_count)
                    self.likeButton.setImage(UIImage(named: "star_filled.png"), forState: UIControlState.Normal)
                    self.likeButton.tintColor = UIColor.yellowColor()
                }
            })
        } else {//unlike it
            TwitterClient.sharedInstance.unfavorite(["id" : tweet.id!], completion: { (tweet: Tweet?, error: NSError?) -> () in
                if tweet != nil {
                    self.numberoflikesLabel.text = String(tweet!.favorites_count)
                    self.likeButton.setImage(UIImage(named: "star_unfilled.png"), forState: UIControlState.Normal)
                    self.likeButton.tintColor = UIColor.blueColor()
                }
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        let seg = segue.identifier
        if seg == "ReplyView"{
            let tweet = self.tweet
            let replyViewController = segue.destinationViewController as! ReplyViewController
            replyViewController.tweet = tweet
        } else if seg == "ProfileView" {
            let user = self.tweet.user
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.clicked_user = user
        }
    }
    
    
 }
