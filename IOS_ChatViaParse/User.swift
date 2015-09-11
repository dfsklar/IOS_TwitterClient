//
//  User.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/10/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var handle: String?
    var profileImage: NSURL?
    
    init(dict: NSDictionary) {
        name = dict["name"] as? String
        handle = dict["screen_name"] as? String
        profileImage = NSURL(string: dict["profile_image_url"] as! String)
    }
}
