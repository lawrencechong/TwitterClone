//
//  Tweet.swift
//  TwitterApp
//
//  Created by Lawrence Chong on 2/28/16.
//  Copyright © 2016 Lawrence Chong. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: NSString?
    var timestamp: NSDate?
    var retweet: Int = 0
    var favorites_count: Int = 0
    var user: User?
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        retweet = (dictionary["retweet_count"] as? Int) ?? 0
        favorites_count = (dictionary["favorite_count"] as? Int) ?? 0
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        
        let timestamp_string = dictionary["created_at"] as? String
        
        
        if let timestamp_string = timestamp_string{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestamp_string)
        }
        
    }
    
    class func tweetsWithArray (dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
    
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
