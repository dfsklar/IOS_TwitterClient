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
    
    var userAuthorized: User?
    
    var blockForLoginCompletion: ((user: User?, error: NSError?) -> Void)?
    
    // Magical singleton incantation
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    
    func login(completionBlock: (user: User?, error: NSError?) -> Void) {
        blockForLoginCompletion = completionBlock
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                println("Good to go: we have a request token")
                var authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: { (error: NSError!) -> Void in
                println(error)
                self.blockForLoginCompletion!(user: nil, error: error)
        })
    }
    
    
    func fetchTweets(completionBlock: (result: [Tweet], error: NSError?) -> Void) {

    // PERSISTENCE FOR OFFLINE
        /*
      if let data = NSUserDefaults.standardUserDefaults().objectForKey("tweetfetch") as? NSData {
                if let result = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [Tweet] {
                   completionBlock(result: result, error: nil)
		   return
                }
            }  */

        self.GET("1.1/statuses/home_timeline.json", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var result : [Tweet] = []
                let serRep = (response).serializedRepresentation
                if let listOfTweets = response as? NSArray {
                    for tweetDict in listOfTweets {
                        result.append(Tweet(dict: tweetDict as! NSDictionary))
                    }
                }

		// Persistence for offline development
                // NSUserDefaults.standardUserDefaults().setObject(serRep, forKey: "tweetfetch")
		// NSUserDefaults.standardUserDefaults().synchronize()
		
                completionBlock(result: result, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completionBlock(result:[], error: error)
            }
        )
    }
    

    
    
    func sendTweet(message: String, completionBlock: (error: NSError?) -> Void) {
        
        let params: NSDictionary = ["status": message]
        
        self.POST("1.1/statuses/update.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                completionBlock(error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completionBlock(error: error)
            }
        )
    }

    
    
    func openURL(url: NSURL) -> Void {
        let queryStr = url.query
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: queryStr),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                println("Got our access token")
                
                self.requestSerializer.saveAccessToken(accessToken)
                
                self.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        self.userAuthorized = User(dict: response as! NSDictionary)
                        User.currentUser = self.userAuthorized
                        self.blockForLoginCompletion!(user: self.userAuthorized, error:nil)
                    },
                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        self.blockForLoginCompletion!(user: nil, error: error)
                    }
                )

            },
            failure: { (error: NSError!) -> Void in
                println("Failure")
            }
        )
    }

}
