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
        TwitterClient.sharedInstance.login { (user, error) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("SegueFromLoginToWrapper", sender: self)
            }
        }
    }
    
    
    @IBAction func Action_SignUp(sender: AnyObject) {
    }
    
    
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        if (User.currentUser != nil) {
            self.performSegueWithIdentifier("SegueFromLoginToWrapper", sender: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

