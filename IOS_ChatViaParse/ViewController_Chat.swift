//
//  ViewController_Chat.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/9/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit
import Parse

class ViewController_Chat: UIViewController {
    
    @IBOutlet weak var TextEntry_MessageToSend: UITextView!
    @IBOutlet weak var TextDisplay_History: UITextView!

    func onTimer() {
        var query = PFQuery(className:"Message")
        query.orderByDescending("createdAt")
        query.includeKey("user")
        //query.whereKey("playerName", equalTo:"Sean Plott")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                var htmlStr = ""
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                        var username = ""
                        if let _user = object["user"] as? PFUser {
                            if let _username = _user.username {
                               username = "<b>" + _username + "</b> "
                            }
                        }
                        htmlStr += "<p>" + username + (object["text"] as! String) + "</p>"
                    }
                    var htmlData = htmlStr.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!
                    let attrStr = NSAttributedString(
                        data: htmlData,
                        options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                        documentAttributes: nil,
                        error: nil)!
                    self.TextDisplay_History.attributedText = attrStr
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer", userInfo: nil, repeats: true)
    }
    
    
    
    @IBAction func Button_Send(sender: AnyObject) {
        var newMsg = PFObject(className:"Message")
        newMsg["text"] = TextEntry_MessageToSend.text
        newMsg["user"] = PFUser.currentUser()
        newMsg.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println("Successful save")
            } else {
                // There was a problem, check error.description
            }
        }
    }
}
