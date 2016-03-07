//
//  ReplyViewController.swift
//  TwitterApp
//
//  Created by Lawrence Chong on 3/6/16.
//  Copyright © 2016 Lawrence Chong. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

    @IBOutlet weak var replyText: UITextView!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyText.text = "@" + ((tweet.user?.screenname)! as String)
    }

    
    @IBAction func onReplyButton(sender: AnyObject) {
        
        var statusId: Int? = nil
        if let tweet_id = self.tweet.id {
                    statusId = Int(tweet_id as String)
                }
        TwitterClient.sharedInstance.postStatus(replyText.text!, statusId:  statusId)
        //        self.delegate?.addTweetToTimeline(self)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        navigationController?.popViewControllerAnimated(true)
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
