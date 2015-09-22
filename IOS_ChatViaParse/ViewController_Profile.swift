//
//  ViewController_Profile.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/21/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit

class ViewController_Profile: UIViewController {
    
    @IBOutlet weak var image_profile: UIImageView!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_handle: UILabel!

    
    @IBOutlet weak var count_tweets: UILabel!
    @IBOutlet weak var count_followers: UILabel!
    @IBOutlet weak var count_mentors: UILabel!
    
    @IBOutlet weak var label_whoIsThis: UILabel!
    
    
    var user : User = User.currentUser!
    
    
    override func viewWillAppear(animated: Bool) {
        label_name.text = user.name!
        label_handle.text = "@\(user.handle!)"
        image_profile.setImageWithURL(user.profileImage!)
        count_tweets.text = "\(user.countTweets!)"
        count_followers.text = "\(user.countFollowers!)"
        count_mentors.text = "\(user.countMentors!)"
        label_whoIsThis.text = (User.currentUser == user) ? "You are logged in as:" : "Info about this user:"
    }
    
    
}
