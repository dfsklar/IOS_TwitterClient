//
//  TableCell_Tweet.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/10/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit


protocol Protocol_ActOnTweet {
    func showReplyUI(tweet: Tweet)
    func showUserProfile(user: User)
}


class TableCell_Tweet: UITableViewCell {

    var callerDelegate: Protocol_ActOnTweet?
    
    @IBOutlet weak var image_profile: UIImageView!
    
    @IBOutlet weak var label_dateOfTweet: UILabel!
    @IBOutlet weak var label_idOfTweeter: UITextView!
    @IBOutlet weak var text_tweetBody: UITextView!
    
    @IBOutlet weak var label_countRetweet: UILabel!
    @IBOutlet weak var label_countFave: UILabel!
    
    @IBOutlet weak var buttonimage_retweet: UIButton!
    @IBOutlet weak var buttonimage_fave: UIButton!
    
    
    
    
    var origTweet: Tweet!
    
    
    func nonzeroIntToString (i : Int?) -> String {
        var retval = ""
        if let i = i {
            if (i > 0) {
                retval = String(i)
            }
        }
        return retval
    }
    
    
    
    // A "curation" button is a retweet or fave button.
    // These are special in that they have a state ("nonzero" vs "zero") needing
    // formatting nudges for distinguising.
    func setupCurationButtonState(which: String, button: UIButton, label: UILabel, valCount: Int, valAlreadyByThisUser: Bool) {
        label.text = nonzeroIntToString(valCount)
        let imageToShow = (which + (valAlreadyByThisUser ? "_on" : "" ))
        println(imageToShow)
        button.setImage(UIImage(named: imageToShow)!, forState:UIControlState.Normal)
    }
    
    
    // Perform the act of RETWEETING and "update in place" the fave button and count to provide
    // feedback of the success of the action.
    @IBAction func button_retweet(sender: AnyObject) {
        TwitterClient.sharedInstance.reTweet(origTweet.idStr!) { (error) -> Void in
            if error == nil {
                self.origTweet.thisUserRetweeted = true
                self.origTweet.retweetCount++
                self.setupCurationButtonState("retweet", button: self.buttonimage_retweet, label: self.label_countRetweet, valCount: self.origTweet.retweetCount, valAlreadyByThisUser: true)
            }
        }
    }
    
    
    @IBAction func button_reply(sender: AnyObject) {
        // If the owner/caller of this table view did set up a delegate
        // to handle a reply-flavored compose-tweet action:
        if let delegate = callerDelegate {
            delegate.showReplyUI(self.origTweet)
        }
    }
    
    
    
    @IBAction func button_goToProfile(sender: AnyObject) {
        // If the owner/caller of this table view did set up a delegate
        // to handle a reply-flavored compose-tweet action:
        if let delegate = callerDelegate {
            delegate.showUserProfile(self.origTweet.user!)
        }
    }
    
    
    
    
    
    // Perform the act of FAVORITING and "update in place" the fave button and count to provide
    // feedback of the success of the action.
    @IBAction func button_fave(sender: AnyObject) {
        TwitterClient.sharedInstance.favorThisTweet(origTweet.idStr!) { (error) -> Void in
            if error == nil {
                self.origTweet.thisUserFaved = true
                self.origTweet.favoriteCount++
                self.setupCurationButtonState("favorite", button: self.buttonimage_fave, label: self.label_countFave, valCount: self.origTweet.favoriteCount, valAlreadyByThisUser: true)
            }
        }
    }
    
}
