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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetStack.dataSource = self
        tweetStack.delegate = self
        
        tweetStack.rowHeight = UITableViewAutomaticDimension
        tweetStack.estimatedRowHeight = 66
        
        let collection = TwitterClient.sharedInstance.obtainTweets()
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer", userInfo: nil, repeats: true)
    }
    
    
    
    
    
    func tableView(tweetStack: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("COUNT")
        /*
        if let theList = self.businesses {
            println(theList.count)
            return theList.count
        } else {
            return 0
        }
*/
        return 0
    }
    
    
    
    
    
    func tableView(tweetStack: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // let details = self.businesses[indexPath.row]
        let cell = self.tweetStack.dequeueReusableCellWithIdentifier("TweetCell") as! TableCell_Tweet
/*        cell.NameBusiness.text = details.name
        cell.imageviewBusiness.setImageWithURL(details.imageURL)
        cell.imageviewRating.setImageWithURL(details.ratingImageURL)
        cell.labelDistanceAddress.text = details.address!
        cell.labelDistance.text = details.distance!
 */       return cell
    }
    
    
    
    
}
