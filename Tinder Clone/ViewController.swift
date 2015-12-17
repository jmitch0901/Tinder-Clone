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
import Parse

var parseUserInfo: PFObject?

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    let loginManager = FBSDKLoginManager()

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error != nil {
            print("There was an error logging in:")
            if let error = error {
                print(error)
            }
            return
        }
        
        if let result = result{
            //print(result)
            //print("Granted permissions: \(result.grantedPermissions)")
            
            if result.declinedPermissions.count > 0 {
                print("Declined permissions: \(result.declinedPermissions)")
            }
            
            self.makeMeRequest()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("Bye bye!")
    }
    
    func makeMeRequest(){
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,name,gender"])
            .startWithCompletionHandler({ (connection, data, error) -> Void in
                
                if error != nil{
                    print("There was an error while querying facebook! \(error)")
                    self.showQuickAlert("Error", message: String(error!))
                    return
                }
                
                //print(connection)
                //print(data)
                if let data = data as? NSDictionary{
                    print(data)
                    //Start importing PFUser information
                   // userData = data
                    self.uploadUserToParse(data)
                } else {
                    self.showQuickAlert("Error", message: "There was an error requesting Facebook. Please try again.")
                }
                
            })
    }
    
    func goIntoApp(showMainApp: Bool){
        if showMainApp {
            //self.performSegueWithIdentifier("mainAppSegue", sender: nil)
            //self.performSegueWithIdentifier("genderPreferenceSegue", sender: nil)
        } else {
            print("Performing Segue")
            self.performSegueWithIdentifier("genderPreferenceSegue", sender: nil)
        }
    }
    
    func showQuickAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action:UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func uploadUserToParse(userData: NSDictionary){
        
        
        let userQuery = PFQuery(className: "TinderInfo")
        userQuery.whereKey("facebook_id", equalTo: userData["id"]!)
        
        
        userQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?,error: NSError?) -> Void in
            
            if error != nil {
                print("There was a parse error querying data for user: \(error!)")
                return
            }
            
            if let objects = objects {
                
                if objects.count == 0{
                    
                    let data = userData
                    let object = PFObject(className: "TinderInfo")
                    object["facebook_id"] = data["id"]
                    object["name"] = data["name"]
                    object["isMale"] = Bool(String(data["gender"]!) == "male")
                    object.saveInBackground()
                    
                    parseUserInfo = object
                    
                } else {
                
                    
                    //Update existing info
                    for object in objects {
                        
                        let data = userData
                        object["facebook_id"] = data["id"]
                        object["name"] = data["name"]
                        object["isMale"] = Bool(String(data["gender"]!) == "male")
                        object.saveInBackground()
                        
                        parseUserInfo = object
                        
                        
                    }
                }
                
                self.goIntoApp(parseUserInfo != nil && parseUserInfo!["prefersWomen"] != nil)
                
            } else {
                print("no objects found")
            }
            
            
            
        })
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.delegate = self
        loginButton.readPermissions = ["user_friends","email","public_profile"]
        if FBSDKAccessToken.currentAccessToken() != nil {
            print("You're already logged in")
            self.makeMeRequest()
            
        }
        
        
    }
    
}

