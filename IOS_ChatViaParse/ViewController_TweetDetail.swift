//
//  ViewController_TweetDetail.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/14/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit

class ViewController_TweetDetail: UIViewController {
    
    var origTweet: Tweet!
    
    
    @IBOutlet weak var imageview_Profile: UIImageView!
    
    @IBOutlet weak var label_Name: UILabel!
    @IBOutlet weak var label_Handle: UILabel!
    
    @IBOutlet weak var textview_Body: UITextView!
    
    @IBOutlet weak var buttonimage_retweet: UIButton!
    @IBOutlet weak var buttonimage_fave: UIButton!
    
    @IBOutlet weak var label_countRetweet: UILabel!
    @IBOutlet weak var label_countFave: UILabel!
    
    
    
    
    @IBAction func button_Retweet(sender: AnyObject) {
        TwitterClient.sharedInstance.reTweet(origTweet.idStr!, completionBlock: { (error) -> Void in
            if (error == nil) {
                self.origTweet.thisUserRetweeted = true
                self.origTweet.retweetCount++
                self.refresh()
            }
        })
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewC = segue.destinationViewController as? ViewController_Compose {
            destinationViewC.originalTweet = self.origTweet
        }
    }

    @IBAction func button_Reply(sender: AnyObject) {
        performSegueWithIdentifier("SegueFromDetailToReply", sender: self)
    }
    
    

    @IBAction func button_Fave(sender: AnyObject) {
        TwitterClient.sharedInstance.favorThisTweet(origTweet.idStr!, completionBlock:  { (error) -> Void in
            if (error == nil) {
                self.origTweet.thisUserFaved = true
                self.origTweet.favoriteCount++
                self.refresh()
            }
        })
    }
    
    
    
    
    
    
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
    
    
    
    func refresh() {
        self.setupCurationButtonState("favorite", button: self.buttonimage_fave, label: self.label_countFave, valCount: self.origTweet.favoriteCount, valAlreadyByThisUser: self.origTweet.thisUserFaved)
        self.setupCurationButtonState("retweet", button: self.buttonimage_retweet, label: self.label_countRetweet, valCount: self.origTweet.retweetCount, valAlreadyByThisUser: self.origTweet.thisUserRetweeted)
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theTweet = origTweet
        
        textview_Body.text = theTweet.text
        
        label_Name.text = theTweet.user!.name
        label_Handle.text = "@" + theTweet.user!.handle!
        
        imageview_Profile.setImageWithURL(theTweet.user!.profileImage)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "RequestToDetailView_close", name: "RequestToDetailView_close", object: nil)
        
        refresh()
    }


    func RequestToDetailView_close() {
        dismissViewControllerAnimated(true, completion: nil)
        println("HELLO i should close")    	 
    }
}
