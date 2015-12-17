//
//  GenderPreferenceViewController.swift
//  Tinder Clone
//
//  Created by Jonathan Mitchell on 12/17/15.
//  Copyright © 2015 nuapps. All rights reserved.
//

import UIKit

class GenderPreferenceViewController: UIViewController {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var genderPreference: UISegmentedControl!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = parseUserInfo{
            if let name = data["name"] {
                userName.text = String(name)
            }
            
            if let id = data["facebook_id"]{
                let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large")!
                
                NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: url), completionHandler: {
                    (data:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    
                    if error != nil {
                        print("Error getting image: \(error!)")
                    }
                    
                    if let data = data{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.userImage.image = UIImage(data: data)
                        })
                    } else {
                        print("No data received for image!")
                    }
                    
                }).resume()
                
            }
        }
    }

    @IBAction func goIntoMainApp(sender: AnyObject) {
        
        if let parseUserInfo = parseUserInfo {
            parseUserInfo["prefersWomen"] = !self.genderPreference.enabled
            parseUserInfo.saveInBackground()
        }
        
        print(parseUserInfo!)
        
        
    }

}
