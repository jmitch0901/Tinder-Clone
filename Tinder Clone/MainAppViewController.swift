//
//  MainAppViewController.swift
//  Tinder Clone
//
//  Created by Jonathan Mitchell on 12/17/15.
//  Copyright © 2015 nuapps. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Parse

class MainAppViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func logout(sender: AnyObject) {
        
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logoutSegue"{
            FBSDKLoginManager().logOut()
        }
    }
}
