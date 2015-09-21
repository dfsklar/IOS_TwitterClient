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
    
    var delegate : Protocol_CenterViewController?

}



extension ViewController_Center: Protocol_LeftViewController {
    func itemSelected() {
        delegate?.collapseSidePanels?()
    }
}
