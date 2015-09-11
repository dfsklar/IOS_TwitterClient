//
//  TwitterClient.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/10/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit

let twitterConsumerKey = "rxwmvp7bs4ScfxC60Sh0y6wVs"
let twitterConsumerSecret = "LH6r3iWcMEbbvLq2rcZtb6HdJz9O6pqPojZfrkT05DamDj7iIh"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1RequestOperationManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }

}
