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
    
    let subview_names = [ "ViewController_TweetStack", "ViewController_Profile", "ViewController_Mentions"]

    let subview_current : String = ""
    
    var subview_controllers = [String:UIViewController]()
    
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    var delegate : Protocol_CenterViewController?
    
    
    
    override func viewWillAppear(animated: Bool) {
        if count(self.subview_controllers.keys) == 0 {
            // We need to initialize the set of subviews
            let sb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            for svname in subview_names {
                let vc = sb.instantiateViewControllerWithIdentifier(svname) as? UIViewController
                subview_controllers[svname] = vc
            }
        }

	setActiveSubview("ViewController_Mentions")
//        setActiveSubview(subview_names.first!)
    }
    
    
    func setActiveSubview(svname: String) {
        if (svname != self.subview_current) {
            
            // Decomission the about-to-be-deactivated VC
            // view.removeFromSuperview()
            // removeFromParentViewController(
            
            let sklar = "sklar"
            
            // Commission the new one
            let new_svc = subview_controllers[svname]!
            view.addSubview(new_svc.view)
            addChildViewController(new_svc)
            new_svc.didMoveToParentViewController(self)
        }
    }
    
    
}



extension ViewController_Center: Protocol_LeftViewController {
    
    func itemSelected(vcname:String) {
        
        // Swap out the current active subVC for the new one
        self.setActiveSubview(vcname)
        
        // Close/cover the side menu panel
        delegate?.collapseSidePanels?()
        
    }
}
