 //
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by Lawrence Chong on 2/28/16.
//  Copyright © 2016 Lawrence Chong. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: [Tweet]!
    
    @IBAction func onLogOutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            }) { (error: NSError) -> () in
                print("error: \(error.localizedDescription)")
        }
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
