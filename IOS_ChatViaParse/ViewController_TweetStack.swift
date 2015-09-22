//
//  ViewController_Chat.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/9/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit




class ViewController_TweetStack: UIViewController, UITableViewDataSource, UITableViewDelegate, Protocol_ActOnTweet {
    
    
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var tweetStack: UITableView!


    // This tweetstack can be used to show any collection of tweets, not just the authuser's own set.
    // These variables set up the "source" and "mode" for the tweet-collection fetching.
    var fetch_mode: TweetFetchMode = .Timeline
    var fetch_userId: String?

    // The result of the fetch operation:
    var tweetCollection : [Tweet] = []
    
    // The tweet/user related to an action requested via interaction with a TweetCell
    var originalTweet : Tweet!
    var userOfInterest : User!


    var refreshControl: UIRefreshControl!

    
    
    func determineTitle() -> String {
        switch fetch_mode {
        case .Mentions:
            return "Mentions of You"
        case .Timeline:
            return "Your Timeline"
        }
    }
    
    func determineLeftRightButtonVis() -> Bool {
        return (fetch_mode == .Timeline) && (fetch_userId == nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetStack.dataSource = self
        tweetStack.delegate = self
        
        navbar.title = determineTitle()
        let showButtons = determineLeftRightButtonVis()
        navbar.leftBarButtonItem!.enabled = !showButtons
        navbar.rightBarButtonItem!.enabled = !showButtons
        
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
        TwitterClient.sharedInstance.fetchTweets(fetch_userId, mode: fetch_mode) { (result, error) -> Void in
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
        
        switch segue.identifier! {
        
        case "SegueShowDetail":
            if let destinationViewC = segue.destinationViewController as? ViewController_TweetDetail {
                if let cell = sender as? UITableViewCell {
                    let indexPathSelectedCell = tweetStack.indexPathForCell(cell)!
                    let detailsDict = tweetCollection[indexPathSelectedCell.row]
                    destinationViewC.origTweet = detailsDict
                    // Deselect the cell that was touched so upon return we have a clean slate
                    tweetStack.deselectRowAtIndexPath(indexPathSelectedCell, animated:false)
                }
            }
            
        case "VC_ComposeReply":
            if let destinationNavC = segue.destinationViewController as? UINavigationController {
                if let vc = destinationNavC.topViewController as? ViewController_Compose {
                    vc.originalTweet_handle = self.originalTweet.user!.handle!
                    vc.originalTweet_id = self.originalTweet.idStr
                }
            }
            
        case "PresentProfileFromTweetStack":
            if let dest = segue.destinationViewController as? UINavigationController {
            
            }
            
        default:
            println("Unexpected segue identifier")
        }
        
    }
    
    


    
    
    
    
    // ACT-ON-TWEET DELEGATE PROTOCOL

    func showReplyUI(tweet: Tweet) {
        self.originalTweet = tweet
        performSegueWithIdentifier("VC_ComposeReply", sender: self)
    }
    
    func showUserProfile(user: User) {
        self.userOfInterest = user
        performSegueWithIdentifier("PresentProfileFromTweetStack", sender: self)
    }
    
    
    
    
    
    
    
    
    // CELL FOR ROW
    func tableView(tweetStack: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tweetStack.dequeueReusableCellWithIdentifier("TweetCell") as! TableCell_Tweet
        
        let theTweet = tweetCollection[indexPath.row]
        let theUser = theTweet.user!
        
        cell.origTweet = theTweet
        
        cell.callerDelegate = self
        
        cell.text_tweetBody.text = theTweet.text
        
        cell.label_idOfTweeter.text = theUser.name! // cleaner without this: + "   @" + theUser.handle!

	// UITextViews have excessive padding that needs to be killed in this tight layout of mine
	cell.label_idOfTweeter.contentInset = UIEdgeInsetsMake(-3,-2,0,0);
        cell.text_tweetBody.contentInset = UIEdgeInsetsMake(-3,-2,0,0);
        
        cell.image_profile.setImageWithURL(theTweet.user!.profileImage)
        
        cell.label_dateOfTweet.text = theTweet.creationTime?.shortTimeAgoSinceNow()
        
        cell.setupCurationButtonState("favorite", button: cell.buttonimage_fave, label: cell.label_countFave, valCount: theTweet.favoriteCount, valAlreadyByThisUser: theTweet.thisUserFaved)
        cell.setupCurationButtonState("retweet", button: cell.buttonimage_retweet, label: cell.label_countRetweet, valCount:theTweet.retweetCount, valAlreadyByThisUser: theTweet.thisUserRetweeted)
        
        return cell
    }
    
    
    
    
}
