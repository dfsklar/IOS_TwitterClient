//
//  ViewController_Chat.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/9/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit

class ViewController_Chat: UIViewController, UITableViewDataSource, UITableViewDelegate , Protocol_ReplyToTweet {
    
    @IBOutlet weak var tweetStack: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    
    func onTimer() {
    }
    
    var tweetCollection : [Tweet] = []
    
    
    @IBAction func handleIntraCellButton_Retweet(sender: AnyObject) {
        let x = "y"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetStack.dataSource = self
        tweetStack.delegate = self
        
        tweetStack.rowHeight = UITableViewAutomaticDimension
        tweetStack.estimatedRowHeight = 200
        
        var swfcfg : SwiftLoader.Config = SwiftLoader.Config()
        swfcfg.backgroundColor = UIColor.blueColor()
        swfcfg.spinnerColor = UIColor.whiteColor()
        SwiftLoader.setConfig(swfcfg)
        
        // Set up "refresh list via swipe gesture" behavior
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:"onRefresh", forControlEvents:UIControlEvents.ValueChanged)
        tweetStack.insertSubview(refreshControl, atIndex: 0)
        
        SwiftLoader.show(animated: false)
        loadOrReloadTweets()
    }
    
    
    @IBAction func Logout(sender: AnyObject) {
        User.currentUser!.logout()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func onRefresh() {
        loadOrReloadTweets()
    }
    
    
    func loadOrReloadTweets() {
        
        TwitterClient.sharedInstance.fetchTweets { (result, error) -> Void in
            self.tweetCollection = result
            self.tweetStack.reloadData()
            SwiftLoader.hide()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    func tableView(tweetStack: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetCollection.count
        
    }
    
    
    
    
    // There are two segues that come out of this ViewController.
    // So this prepare has to bifurcate immediately based on the target/destination VC.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let destinationViewC = segue.destinationViewController as? ViewController_TweetDetail {
            if let cell = sender as? UITableViewCell {
                let indexPathSelectedCell = tweetStack.indexPathForCell(cell)!
                let detailsDict = tweetCollection[indexPathSelectedCell.row]
                let destinationViewC = segue.destinationViewController as! ViewController_TweetDetail
                destinationViewC.details = detailsDict
                // Deselect the cell that was touched so upon return we have a clean slate
                tweetStack.deselectRowAtIndexPath(indexPathSelectedCell, animated:false)
            }
        }

        if let destinationViewC2 = segue.destinationViewController as? ViewController_Compose {
            destinationViewC2.originalTweet = self.originalTweet
        }

    }
    
    


    
    
    // An HTML-to-attributedstring utility, borrowed from:
    // http://stackoverflow.com/questions/27164928/create-an-attributed-string-out-of-plain-android-formated-text-in-swift-for-io
    //
    func convertText(inputText: String) -> NSAttributedString {
        
        var html = inputText
        
        // Replace newline character by HTML line break
        while let range = html.rangeOfString("\n") {
            html.replaceRange(range, with: "<br />")
        }
        
        let data = html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!
        let attrStr = NSAttributedString(
            data: data,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil,
            error: nil)!
        return attrStr
    }
    
    
    
    // REPLY-TO-TWEET DELEGATE PROTOCOL
    
    var originalTweet : Tweet?
    
    func showReplyUI(tweet: Tweet) {
        originalTweet = tweet
        performSegueWithIdentifier("VC_ComposeReply", sender: self)
    }
    
    
    
    // CELL FOR ROW
    func tableView(tweetStack: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tweetStack.dequeueReusableCellWithIdentifier("TweetCell") as! TableCell_Tweet
        
        let theTweet = tweetCollection[indexPath.row]
        let theUser = theTweet.user!
        
        cell.origTweet = theTweet
        
        cell.callerDelegate = self
        
        cell.text_tweetBody.text = theTweet.text
        
        cell.label_idOfTweeter.text = theUser.name! + "   @" + theUser.handle!
        /*
        cell.label_idOfTweeter.attributedText = convertText("<span style='font-size:10px;font-family:Arial'>" + theUser.name! + " <span style='color:grey'> @"+theUser.handle!+"</span></span>")
        */
        cell.label_idOfTweeter.contentInset = UIEdgeInsetsMake(-3,-2,0,0);
        cell.text_tweetBody.contentInset = UIEdgeInsetsMake(-3,-2,0,0);
        
        cell.image_profile.setImageWithURL(theTweet.user!.profileImage)
        
        cell.label_dateOfTweet.text = theTweet.creationTime?.shortTimeAgoSinceNow()
        
        cell.setupCurationButtonState("favorite", button: cell.buttonimage_fave, label: cell.label_countFave, valCount: theTweet.favoriteCount, valAlreadyByThisUser: theTweet.thisUserFaved)
        cell.setupCurationButtonState("retweet", button: cell.buttonimage_retweet, label: cell.label_countRetweet, valCount:theTweet.retweetCount, valAlreadyByThisUser: theTweet.thisUserRetweeted)
        
        return cell
    }
    
    
    
    
}
