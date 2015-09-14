//
//  ViewController_TweetDetail.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/14/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit

class ViewController_TweetDetail: UIViewController {
    
    var details: Tweet!
    
    
    @IBOutlet weak var imageview_Profile: UIImageView!
    
    @IBOutlet weak var label_Name: UILabel!
    @IBOutlet weak var label_Handle: UILabel!
    
    @IBOutlet weak var textview_Body: UITextView!
    
    @IBAction func button_Retweet(sender: AnyObject) {
    }
    @IBAction func button_Reply(sender: AnyObject) {
    }
    @IBAction func button_Fave(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theTweet = details
        
        textview_Body.text = theTweet.text
        
        label_Name.text = theTweet.user!.name
        label_Handle.text = theTweet.user!.handle
        
        imageview_Profile.setImageWithURL(theTweet.user!.profileImage)
        
    }
    
}
