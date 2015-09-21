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
    func itemSelected()
}


class ViewController_Menu: UIViewController {
    
      var delegate: Protocol_LeftViewController?

}
