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
    
    let data = parseUserInfo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        image.addGestureRecognizer(gesture)
        image.userInteractionEnabled = true

        
    }

    @IBAction func logout(sender: AnyObject) {
        
        
        
        
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer){
        
        //print("was dragged")
        let translation = gesture.translationInView(self.view) //gesture gives us actual tied object to be panned. AKA the label
        
        //print(translation)
        
        let label = gesture.view!
        
        let xDelta = label.center.x - self.view.bounds.width/2
        
        let scale = min(100 / abs(xDelta),1)
        
        var rotation = CGAffineTransformMakeRotation(xDelta / 200)
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        
        
        label.transform = stretch
        
        
        
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        
        if gesture.state == .Ended {
            
            if label.center.x < 100{
                print("Not Chosen")
            } else if label.center.x > self.view.bounds.width - 100 {
                print("Chosen")
            }
            
            
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            label.transform = stretch
            
            
            label.center = self.view.center
        }
        
        
        
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logoutSegue"{
            FBSDKLoginManager().logOut()
        }
    }
}
