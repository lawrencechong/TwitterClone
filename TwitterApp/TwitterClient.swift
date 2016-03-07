//
//  TwitterClient.swift
//  TwitterApp
//
//  Created by Lawrence Chong on 2/28/16.
//  Copyright © 2016 Lawrence Chong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "UbDPlBmwA8KeddUhBGlt8Amud", consumerSecret: "jBtQV71wJxyRnOVv6C9taUEyFzoJogmy3MN7lyA1vtLv61vs1B")
    
    var loginSuccess:  (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func homeTimeLine(success: ([Tweet]) -> (), failure: (NSError) -> () ){
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Couldn't get tweets")
                failure(error)
        })
    }
    
    func current_account(success: (User) -> (), failure: (NSError) -> () ){
        
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Couldn't get user")
                failure(error)
        })
    }
    
    func retweet(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(id).json",
            parameters: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("posted retweet")
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error retweeting")
                print(error)
                completion(tweet: nil, error: error)
            }
        )
    }
    
    func unretweet(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/unretweet/\(id).json",
            parameters: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("unretweeted")
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error unretweeting")
                print(error)
                completion(tweet: nil, error: error)
            }
        )
    }
    
    func favorite(params: NSDictionary!, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/create.json",
            parameters: params,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("favorited tweet")
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error favoriting tweet")
                print(error)
                completion(tweet: nil, error: error)
            }
        )
    }

    func unfavorite(params: NSDictionary!, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/destroy.json",
            parameters: params,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("unfavorited tweet")
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error unfavoriting tweet")
                print(error)
                completion(tweet: nil, error: error)
            }
        )
    }
    
    func postTweet(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json",
            parameters: params,
            progress: { (progress: NSProgress) -> Void in },
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error creating tweet")
                completion(tweet: nil, error: error)
        })
    }
    
    func postStatus(tweetMsg: String, statusId: Int?) {
        var params = ["status": tweetMsg]
        if statusId != nil {
            params["in_reply_to_status_id"] = String(statusId!)
        }
        
        POST("1.1/statuses/update.json", parameters: params,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Posted status: \(tweetMsg)")
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error)
        })
    }
    
    
    func login(success: () -> (), failure: (NSError) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("I got a token")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func logout(){
        User.current_user = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogOutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) -> Void in
            self.current_account({ (user: User) -> () in
                User.current_user = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
        
    }
}
