//
//  ViewController_Compose.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/14/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit

class ViewController_Compose: UIViewController {
    
    @IBOutlet weak var textview_MessageBody: UITextView!

    @IBOutlet weak var image_ProfileOfComposer: UIImageView!

    @IBOutlet weak var label_Handle: UILabel!
    @IBOutlet weak var label_Name: UILabel!

    // If this compose is a reply
    var originalTweet_handle : String?
    var originalTweet_id : String?
    
    

    
    
    override func viewWillAppear(animated:Bool) {
        if let user = User.currentUser {
            if let url = user.profileImage {
                image_ProfileOfComposer.setImageWithURL(url)
                label_Handle.text = "@" + user.handle!
                label_Name.text = user.name
            }
        }
        
        // Reply mode?
        if originalTweet_id != nil {
            self.textview_MessageBody.text = "@" + self.originalTweet_handle! + " "
        }
        
        self.textview_MessageBody.becomeFirstResponder()
    }
    
 
    
    @IBAction func handleButton_Send(sender: AnyObject) {
        if let origID = self.originalTweet_id {
            TwitterClient.sharedInstance.sendReplyTweet(textview_MessageBody.text, originalTweetID: origID) { (error) -> Void in
                if error == nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    println("Whoa we got an error trying to tweet")
                    println(error?.description)
                }
            }
        } else {
            TwitterClient.sharedInstance.sendTweet(textview_MessageBody.text) { (error) -> Void in
                if error == nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    println("Whoa we got an error trying to tweet")
                    println(error?.description)
                }
            }
        }
    }
    
    
    @IBAction func handleButton_Cancel(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "originalTweetForReply")
        dismissViewControllerAnimated(true, completion: nil)
    }


}
