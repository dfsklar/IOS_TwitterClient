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
    

    func onTimer() {
    }
    
    var tweetCollection : [Tweet] = []
    
    
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
    
        loadOrReloadTweets()
    }
    
    

    func loadOrReloadTweets() {
        SwiftLoader.show(animated: false)
        TwitterClient.sharedInstance.fetchTweets { (result, error) -> Void in
            self.tweetCollection = result
            self.tweetStack.reloadData()
            SwiftLoader.hide()
        }
    }
    
    
    func tableView(tweetStack: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetCollection.count
        
    }
    
    
    
    
    
    func tableView(tweetStack: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tweetStack.dequeueReusableCellWithIdentifier("TweetCell") as! TableCell_Tweet
        
        let theTweet = tweetCollection[indexPath.row]
        cell.text_tweetBody.text = theTweet.text
        cell.label_idOfTweeter.text = theTweet.user!.name
        
        cell.label_idOfTweeter.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
        cell.text_tweetBody.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
        
        cell.image_profile.setImageWithURL(theTweet.user!.profileImage)
        
        return cell
    }
    
    
    
    
}
