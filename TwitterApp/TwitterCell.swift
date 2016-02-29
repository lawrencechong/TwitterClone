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
            
            if tweet.user?.profile_url != nil {
                profileImageView.setImageWithURL((tweet.user?.profile_url)!)
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
    }

    @IBAction func onLikeButton(sender: AnyObject) {
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
