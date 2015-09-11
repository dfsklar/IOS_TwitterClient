//
//  ViewController.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/9/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit




class ViewController_Login: UIViewController {
    @IBOutlet weak var TextEntry_Username: UITextField!
    @IBOutlet weak var TextEntry_Password: UITextField!
    

    

    @IBAction func Action_SignIn(sender: AnyObject) {
        println("Login")
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in println("Good to go") }) { (error: NSError!) -> Void in println("Not fun")}
        /*
        PFUser.logInWithUsernameInBackground(TextEntry_Username.text, password: TextEntry_Password.text) {
            (userSuccess: PFUser?, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                println(errorString)
            } else {
                if userSuccess != nil {
                    println("You are all set!")
                    self.performSegueWithIdentifier("SegueFromLoginToChat", sender: self)
                }
            }
        }
*/
    }
    
    
    @IBAction func Action_SignUp(sender: AnyObject) {
        /*
        var user = PFUser()
        user.username = TextEntry_Username.text
        user.password = TextEntry_Password.text
        user.email = user.username
        // other fields can be set just like with PFObject
        // user["phone"] = "415-392-0202"
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                println(errorString)
            } else {
                println("You are all set!")
            }
        }
*/
    }
    
    
    
    
    
    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)
        /*
        var currentUser = nil // PFUser.currentUser()
        if currentUser != nil {
            println("Yes we have a current user")
            self.performSegueWithIdentifier("SegueFromLoginToChat", sender: self)
        }
*/
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

