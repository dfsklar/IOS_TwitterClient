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


enum TweetFetchMode {
    case Timeline
    case Mentions
}

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
    
    
    
    
    
    
    
    
    func fetchUserProfile(userId: String?, completionBlock: (user: User?, error: NSError?) -> Void) {
        
        var params = [String: String]()
        params["user_id"] = userId!
        
        self.GET("1.1/users/show.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                if let dict = response as? NSDictionary {
                    let thisUser = User(dict: dict)
                    completionBlock(user: thisUser, error: nil)
                } else {
                    completionBlock(user: nil, error: nil)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completionBlock(user: nil, error: error)
            }
        )
    }
    
    
    

    
    // If a user is provided, this will obtain an arbitrary user timeline.
    // Otherwise, it will obtain the "home timeline" or "mentioned-in timeline" of the auth'd user.
    
    func fetchTweets(idUser: String?, mode: TweetFetchMode, completionBlock: (result: [Tweet], error: NSError?) -> Void) {
        var params = [String: String]()
        var urlGet = "1.1/statuses/home_timeline.json"
        if let idUser = idUser {
            params["user_id"] = idUser
            urlGet = "1.1/statuses/user_timeline.json"
        } else {
            if mode == TweetFetchMode.Mentions {
                urlGet = "1.1/statuses/mentions_timeline.json"
            }
        }
        
        self.GET(urlGet, parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var result : [Tweet] = []
                if let listOfTweets = response as? NSArray {
                    for tweetDict in listOfTweets {
                        result.append(Tweet(dict: tweetDict as! NSDictionary))
                    }
                }
                completionBlock(result: result, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completionBlock(result:[], error: error)
            }
        )
    }
    
    
    
    
    
    
    func reTweet(idStr: String, completionBlock: (error: NSError?) -> Void) {
        
        let params: NSDictionary = ["id": idStr]
        
        self.POST("1.1/statuses/retweet/" + idStr + ".json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                completionBlock(error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completionBlock(error: error)
            }
        )
    }
    
    
    
    
    
    func favorThisTweet(idStr: String, completionBlock: (error: NSError?) -> Void) {
        
        let params: NSDictionary = ["id": idStr]
        
        self.POST("1.1/favorites/create.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                completionBlock(error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completionBlock(error: error)
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
    
    

   
    
    
    func sendReplyTweet(message: String, originalTweetID: String, completionBlock: (error: NSError?) -> Void) {
        
        let params: NSDictionary = [
            "status": message,
            "in_reply_to_status_id": originalTweetID
        ]
        
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
