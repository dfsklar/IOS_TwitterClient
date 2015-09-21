//
//  ViewController_Center.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/21/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit


@objc
protocol Protocol_CenterViewController {
    optional func toggleLeftPanel()
    optional func collapseSidePanels()
}



class ViewController_Center: UIViewController {
    
      class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }

    var delegate : Protocol_CenterViewController?

    
    override func viewWillAppear(animated: Bool) {
        let me = "do this"
        
        let navc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ViewController_TweetStack") as? UINavigationController
        
        view.addSubview(navc!.view)
        addChildViewController(navc!)
        navc!.didMoveToParentViewController(self)
    }





}



extension ViewController_Center: Protocol_LeftViewController {
    func itemSelected() {
        delegate?.collapseSidePanels?()
    }
}
