//
//  User.swift
//  TwitterApp
//
//  Created by Lawrence Chong on 2/28/16.
//  Copyright © 2016 Lawrence Chong. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profile_url: NSURL?
    var profile_background_url: NSURL?
    var tagline: NSString?
    var tweets: Int = 0
    var followers: Int = 0
    var following: Int = 0
    
    var dictionary: NSDictionary?
    
    static let userDidLogOutNotification = "UserDidLogOut"
    
    init(dictionary: NSDictionary){
        
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profile_url_string = dictionary["profile_image_url_https"] as? String
        
        if let profile_url_string = profile_url_string {
            profile_url = NSURL(string: profile_url_string)
        }
        
        let profile_background_url_string = dictionary["profile_background_image_url_https"] as? String
        
        if let profile_background_url_string = profile_background_url_string {
            profile_background_url = NSURL(string: profile_background_url_string)
        }
        
        tagline = dictionary["description"] as? String
        
        tweets = (dictionary["statuses_count"] as? Int) ?? 0
         following = (dictionary["friends_count"] as? Int) ?? 0
        followers = (dictionary["followers_count"] as? Int) ?? 0
    }
    
    static var _currentUser: User?
    
    class var current_user: User? {
        get {
            if _currentUser == nil {
        
                let defaults = NSUserDefaults.standardUserDefaults()
        
                let data = defaults.objectForKey("currentUserData") as? NSData
                if let data = data {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
                    _currentUser = User(dictionary: dictionary!)
                }
            }
            return _currentUser
        }
        set (user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
