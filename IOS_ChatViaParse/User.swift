//
//  User.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/10/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit

// Because we don't have class variables in Swift:
var _currentUser: User?

let key_CurrentUser = "key_CurrentUser"

let notif_userDidLogin = "userDidLoginNotification"
let notif_userDidLogout = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var handle: String?
    var profileImage: NSURL?
    var bgImage: NSURL?
    var serialization: NSDictionary
    
    var countTweets: Int?
    var countFollowers: Int?
    var countMentors: Int?
    
    init(dict: NSDictionary) {
        serialization = dict
        name = dict["name"] as? String
        handle = dict["screen_name"] as? String
        profileImage = NSURL(string: dict["profile_image_url"] as! String)
        bgImage = NSURL(string: dict["profile_background_image_url"] as! String)
        countTweets = dict["statuses_count"] as? Int
        countMentors = dict["friends_count"] as? Int
        countFollowers = dict["followers_count"] as? Int
    }
    

    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(notif_userDidLogout, object: nil)
    }
    
    
    class var currentUser: User? {
        get {
        if _currentUser == nil {
            if let data = NSUserDefaults.standardUserDefaults().objectForKey(key_CurrentUser) as? NSData {
                if let dictFromPersistence = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                    _currentUser = User(dict: dictFromPersistence)
                }
            }
        }
        return _currentUser
        }
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.serialization, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: key_CurrentUser)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: key_CurrentUser)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
    }
    
    
}
