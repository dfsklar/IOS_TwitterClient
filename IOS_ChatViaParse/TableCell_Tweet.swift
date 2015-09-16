//
//  TableCell_Tweet.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/10/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit

class TableCell_Tweet: UITableViewCell {

    
    @IBOutlet weak var image_profile: UIImageView!
    
    @IBOutlet weak var label_dateOfTweet: UILabel!
    @IBOutlet weak var label_idOfTweeter: UITextView!
    @IBOutlet weak var text_tweetBody: UITextView!
    
    @IBOutlet weak var label_countRetweet: UILabel!
    @IBOutlet weak var label_countFave: UILabel!
    
    @IBOutlet weak var buttonimage_retweet: UIButton!
    @IBOutlet weak var buttonimage_fave: UIButton!
    
    
    @IBAction func handleRetwe(sender: AnyObject) {
        let x = "y"
    }
    
    
    @IBAction func button_reply(sender: AnyObject) {
    }
    
    @IBAction func button_fave(sender: AnyObject) {
    }
    
}
