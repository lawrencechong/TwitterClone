//
//  NewPostViewController.swift
//  TwitterApp
//
//  Created by Lawrence Chong on 3/6/16.
//  Copyright © 2016 Lawrence Chong. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNamLabel: UILabel!
    
    @IBOutlet weak var tweetText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = User.current_user?.name as? String
        screenNamLabel.text = "@" + (User.current_user?.screenname as? String)!
        if User.current_user?.profile_url != nil {
            profileImageView.setImageWithURL((User.current_user?.profile_url)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onTweetButton(sender: AnyObject) {
        var statusId: Int? = nil
//        if let destUser = self.destUser {
//            statusId = destUser.id!
//        }
        TwitterClient.sharedInstance.postStatus(tweetText.text!, statusId:  statusId)
//        self.delegate?.addTweetToTimeline(self)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        navigationController?.popViewControllerAnimated(true)
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
