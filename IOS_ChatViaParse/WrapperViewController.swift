//
//  WrapperViewController.swift
//  IOS_ChatViaParse
//
//  Created by David Sklar on 9/21/15.
//  Copyright (c) 2015 David Sklar. All rights reserved.
//

import UIKit
import QuartzCore


/*

This pattern and much of the code was inspired and borrowed from
Ray Wenderlich's excellent tutorial on implementation of
slide-out navigation panels.

*/


enum SlideOutState {
    case LeftPanelCollapsed
    case LeftPanelExpanded
}


class WrapperViewController: UIViewController {
    
    var centerNavigationController: UINavigationController!
    var centerViewController: ViewController_Center!
    
    
    var currentState: SlideOutState = .LeftPanelCollapsed {
        didSet {
            let shouldShowShadow = currentState != .LeftPanelCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var menuViewController: ViewController_Menu?
    
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        
        view.addSubview(centerViewController.view)
        addChildViewController(centerViewController)
        centerViewController.didMoveToParentViewController(self)
        centerViewController.view.addGestureRecognizer(panGestureRecognizer)        
    }
    
}





extension WrapperViewController: Protocol_CenterViewController {
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }

    
    func collapseSidePanels() {
        switch (currentState) {
        case .LeftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        if (menuViewController == nil) {
            menuViewController = UIStoryboard.leftViewController()
            
            addChildSidePanelController(menuViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: ViewController_Menu) {
        sidePanelController.delegate = centerViewController
        
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    
    func animateLeftPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerViewController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .LeftPanelCollapsed
                
                self.menuViewController!.view.removeFromSuperview()
                self.menuViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerViewController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerViewController.view.layer.shadowOpacity = 0.8
        } else {
            centerViewController.view.layer.shadowOpacity = 0.0
        }
    }
    
}




extension WrapperViewController: UIGestureRecognizerDelegate {
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Began:
            if (currentState == .LeftPanelCollapsed) {
                if (gestureIsDraggingFromLeftToRight) {
                    addLeftPanelViewController()
                }
                showShadowForCenterViewController(true)
            }
        case .Changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
            recognizer.setTranslation(CGPointZero, inView: view)
        case .Ended:
            // animate the side panel open or closed based on whether the view has moved more or less than halfway
            let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
            animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
        default:
            break
        }
    }
}



private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> ViewController_Menu? {
        let retval = mainStoryboard().instantiateViewControllerWithIdentifier("MenuViewController") as? ViewController_Menu
        return retval
    }
    
    class func centerViewController() -> ViewController_Center? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? ViewController_Center
    }
}



