//
//  ViewController_Mentions.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/21/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit

class ViewController_Mentions: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        let sb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if let navController = sb.instantiateViewControllerWithIdentifier("ViewController_TweetStack") as? UINavigationController {
            
            let vc = navController.viewControllers.first! as! ViewController_TweetStack

            vc.fetch_mode = TweetFetchMode.Mentions
        
            view.addSubview(navController.view)
            addChildViewController(navController)
            navController.didMoveToParentViewController(self)
        }

        super.viewWillAppear(animated)
    }

    
}
