//
//  TwitterCell.swift
//  TwitterApp
//
//  Created by Lawrence Chong on 2/28/16.
//  Copyright © 2016 Lawrence Chong. All rights reserved.
//

import UIKit

class TwitterCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    var tweet : Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name as? String
            tweetLabel.text = tweet.text as? String
            screennameLabel.text = "@" + (tweet.user?.screenname as? String)!
            retweetCountLabel.text = String(tweet.retweet)
            likeCountLabel.text = String(tweet.favorites_count)
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            
            let dateString = formatter.stringFromDate(tweet.timestamp!)
            
            timeLabel.text = dateString
            
            if tweet.user?.profile_url != nil {
                profileImageView.setImageWithURL((tweet.user?.profile_url)!)
            }
            
            if tweet.retweeted == true {
                retweetCountLabel.textColor = UIColor.purpleColor()
            }
            
            if tweet.favorited == true {
                likeCountLabel.textColor = UIColor.orangeColor()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        if tweet.retweeted == false { //retweet it!
            TwitterClient.sharedInstance.retweet(tweet.id! as String, completion: { (tweet: Tweet?, error: NSError?) -> () in
                if tweet != nil {
                    self.retweetCountLabel.text = String(tweet!.retweet)
                    self.retweetCountLabel.textColor = UIColor.greenColor()
                }
            })
        } else { //unretweet it
            TwitterClient.sharedInstance.unretweet(tweet.id! as String, completion: { (tweet: Tweet?, error: NSError?) -> () in
                if tweet != nil {
                    self.retweetCountLabel.text = String(tweet!.retweet)
                    self.retweetCountLabel.textColor = UIColor.blueColor()
                }            })
        }
    }
    
    @IBAction func onLikeButton(sender: AnyObject) {
        if tweet.favorited == false {
            TwitterClient.sharedInstance.favorite(["id" : tweet.id!], completion: { (tweet: Tweet?, error: NSError?) -> () in
                if tweet != nil {
                    self.likeCountLabel.text = String(tweet!.favorites_count)
                    self.likeCountLabel.textColor = UIColor.redColor()
                }
            })
        } else {
            TwitterClient.sharedInstance.unfavorite(["id" : tweet.id!], completion: { (tweet: Tweet?, error: NSError?) -> () in
                if tweet != nil {
                    self.likeCountLabel.text = String(tweet!.favorites_count)
                    self.likeCountLabel.textColor = UIColor.blueColor()
                }
            })
        }
        
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
