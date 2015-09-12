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
    
    
    
    @IBAction func button_retweet(sender: AnyObject) {
        
    }
    

    // The UITextView showing name and handle is a bitch, try this:
    // *instanceOfUITextView*.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
    
}
