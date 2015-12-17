//
//  ViewController.swift
//  Tinder Clone
//
//  Created by Jonathan Mitchell on 12/16/15.
//  Copyright © 2015 nuapps. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fbButton = FBSDKLoginButton()
        fbButton.center = self.view.center
        self.view.addSubview(fbButton)
        
        
        
    }
}

