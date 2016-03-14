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
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
//    var retweeted : Bool = false
//    var favorited : Bool = false
    
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
            
            let tapped = UITapGestureRecognizer(target: self, action:Selector("tapped:"))
            profileImageView.addGestureRecognizer(tapped)
            profileImageView.userInteractionEnabled = true

            likeButton.setTitle(nil, forState: UIControlState.Normal)
            retweetButton.setTitle(nil, forState: UIControlState.Normal)
            
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
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func tapped(sender: UITapGestureRecognizer)
    {
        print("I went through here")
        //return self.tweet
    }
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        if self.tweet.retweeted == false { //retweet it!
            TwitterClient.sharedInstance.retweet(tweet.id! as String, completion: { (tweet: Tweet?, error: NSError?) -> () in
                if tweet != nil {
                    self.retweetCountLabel.text = String(tweet!.retweet)
                    self.retweetButton.setImage(UIImage(named: "retweeted.png"), forState: UIControlState.Normal)
                    self.retweetButton.tintColor = UIColor.greenColor()
                    self.tweet.retweeted = true
                }
            })
        } else { //unretweet it
            TwitterClient.sharedInstance.unretweet(tweet.id! as String, completion: { (tweet: Tweet?, error: NSError?) -> () in
                if tweet != nil {
                    self.retweetCountLabel.text = String(tweet!.retweet)
                    self.retweetButton.setImage(UIImage(named: "retweet.png"), forState: UIControlState.Normal)
                    self.retweetButton.tintColor = UIColor.blueColor()
                    self.tweet.retweeted = false
    
                }            })
        }
    }
    
    @IBAction func onLikeButton(sender: AnyObject) {
        if self.tweet.favorited == false { //like it
            TwitterClient.sharedInstance.favorite(["id" : tweet.id!], completion: { (tweet: Tweet?, error: NSError?) -> () in
                if tweet != nil {
                    self.likeCountLabel.text = String(tweet!.favorites_count)
                    self.likeButton.setImage(UIImage(named: "star_filled.png"), forState: UIControlState.Normal)
                    self.likeButton.tintColor = UIColor.yellowColor()
                    self.tweet.favorited = true
                }
            })
        } else {//unlike it
            TwitterClient.sharedInstance.unfavorite(["id" : tweet.id!], completion: { (tweet: Tweet?, error: NSError?) -> () in
                if tweet != nil {
                    self.likeCountLabel.text = String(tweet!.favorites_count)
                    self.likeButton.setImage(UIImage(named: "star_unfilled.png"), forState: UIControlState.Normal)
                    self.likeButton.tintColor = UIColor.blueColor()
                    self.tweet.favorited = false
                }
            })
        }
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
