//
//  ViewController_Chat.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/9/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit

class ViewController_Chat: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UITableViewCell {
            let indexPathSelectedCell = tweetStack.indexPathForCell(cell)!
            if let detailsDict = tweetCollection[indexPathSelectedCell.row] as? Tweet {
                let destinationViewC = segue.destinationViewController as! ViewController_TweetDetail
                destinationViewC.details = detailsDict
                // Deselect the cell that was touched so upon return we have a clean slate
                tweetStack.deselectRowAtIndexPath(indexPathSelectedCell, animated:false)
            }
        }
    }
    
    
    // CELL FOR ROW
    func tableView(tweetStack: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tweetStack.dequeueReusableCellWithIdentifier("TweetCell") as! TableCell_Tweet
        
        let theTweet = tweetCollection[indexPath.row]
        cell.text_tweetBody.text = theTweet.text
        cell.label_idOfTweeter.text = theTweet.user!.name
        
        cell.label_idOfTweeter.contentInset = UIEdgeInsetsMake(-3,-2,0,0);
        cell.text_tweetBody.contentInset = UIEdgeInsetsMake(-3,-2,0,0);
        
        cell.image_profile.setImageWithURL(theTweet.user!.profileImage)
        
        cell.label_dateOfTweet.text = theTweet.creationTime?.shortTimeAgoSinceNow()
        
        return cell
    }
    
    
    
    
}
