//
//  Tweet.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/10/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var creationTime: NSDate?
    
    init(dict: NSDictionary) {
        user = User(dict: dict["user"] as! NSDictionary)
        text = dict["text"] as? String
        if let dateStr = dict["created_at"] as? String {
            let fmt = NSDateFormatter()
            fmt.dateFormat = "EEE MMM d HH:mm:ss Z y"
            creationTime = fmt.dateFromString(dateStr)
        }
    }
}
