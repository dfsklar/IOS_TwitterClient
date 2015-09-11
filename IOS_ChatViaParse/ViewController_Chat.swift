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
        tweetStack.estimatedRowHeight = 66
        
        TwitterClient.sharedInstance.fetchTweets { (result, error) -> Void in
            self.tweetCollection = result
            self.tweetStack.reloadData()
        }
    }
    
    
    
    
    
    func tableView(tweetStack: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("COUNT")
        return tweetCollection.count
    }
    
    
    
    
    
    func tableView(tweetStack: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tweetStack.dequeueReusableCellWithIdentifier("TweetCell") as! TableCell_Tweet
/*        cell.NameBusiness.text = details.name
        cell.imageviewBusiness.setImageWithURL(details.imageURL)
        cell.imageviewRating.setImageWithURL(details.ratingImageURL)
        cell.labelDistanceAddress.text = details.address!
        cell.labelDistance.text = details.distance!
 */       return cell
    }
    
    
    
    
}
