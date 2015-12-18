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
    @IBOutlet weak var mateName: UILabel!
    
    let data = parseUserInfo!
    
    var loverQueue:[PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        image.addGestureRecognizer(gesture)
        image.userInteractionEnabled = true
        
        

        
    }
    
    override func viewDidAppear(animated: Bool) {
        grabLoverQueue()
    }
    
    func grabLoverQueue(){
        let query = PFQuery(className: "TinderInfo")
        

        //SELECT * FROM TinderInfo WHERE isMale = false AND prefersWomen = false

        query.whereKey("isMale", equalTo: Bool(String(data["prefersWomen"]) != "1")) //IF the current user prefers women, query people whos isMale = false
        query.whereKey("prefersWomen", equalTo: Bool(String(data["isMale"]) != "1")) //IF the user is male, query users whos isMale is FALSE
        
        query.selectKeys(["facebook_id","name"])
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error != nil {
                print("Got an error for getting lover queue: \(error!)")
                return
            }
            
            if let objects = objects{
                
                for object in objects {
                    //print(object)
                    self.loverQueue.append(object)
                }
                
                self.queryNext()
                
                
                
            } else {
                print("No objects received from lover query")
            }
        }
        
        
        
    }
    
    func queryNext(){
        
        if loverQueue.count == 0 {
            print("Queue is empty")
            self.image.image = nil
            self.mateName.text = ""
            return
        }
        
        let nextObject = loverQueue.removeFirst()
        
        self.mateName.text = nextObject["name"] as? String
        
        let url = NSURL(string: "https://graph.facebook.com/\(nextObject["facebook_id"])/picture?type=large")!
        
        NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: url), completionHandler: {
            (data:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if error != nil {
                print("Error getting image: \(error!)")
            }
            
            if let data = data{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.image.image = UIImage(data: data)
                })
            } else {
                print("No data received for image!")
            }
            
        }).resume()
        
        
        
        
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
            
            self.queryNext()
        }
        
        
        
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logoutSegue"{
            FBSDKLoginManager().logOut()
        }
    }
}
