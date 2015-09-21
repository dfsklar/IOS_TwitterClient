//
//  ViewController_Menu.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/21/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit


@objc
protocol Protocol_LeftViewController {
    func itemSelected(s:String)
}


class ViewController_Menu: UIViewController {
    
    var delegate: Protocol_LeftViewController?
    
    
    @IBAction func Action_Timeline(sender: AnyObject) {
        delegate!.itemSelected("ViewController_TweetStack")
    }
    
    
    @IBAction func Action_Profile(sender: AnyObject) {
        delegate!.itemSelected("ViewController_Profile")
    }
    
    
    @IBAction func Action_Mentions(sender: AnyObject) {
        delegate!.itemSelected("mentions")
    }
    
}
