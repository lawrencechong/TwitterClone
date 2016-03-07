//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by Lawrence Chong on 3/6/16.
//  Copyright © 2016 Lawrence Chong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var clicked_user: User!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var tweetsCountLabel: UILabel!
    
    @IBOutlet weak var followingCountLablel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = clicked_user.name as? String
        screennameLabel.text = "@" + (clicked_user.screenname as? String)!
        
        if clicked_user.profile_url != nil {
            profileImageView.setImageWithURL((clicked_user.profile_url)!)
        }
        
        if clicked_user.profile_background_url != nil {
            headerImageView.setImageWithURL((clicked_user.profile_background_url)!)
        }
        
        tweetsCountLabel.text = String(clicked_user.tweets)
        followingCountLablel.text = String(clicked_user.following)
        followersCountLabel.text = String(clicked_user.followers)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
