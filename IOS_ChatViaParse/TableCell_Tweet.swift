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
    
    
    @IBAction func handleRetwe(sender: AnyObject) {
        let x = "y"
    }
    
    
    @IBAction func button_reply(sender: AnyObject) {
    }
    
    @IBAction func button_fave(sender: AnyObject) {
    }
    
}
