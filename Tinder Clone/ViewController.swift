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
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,name,email,picture"])
            .startWithCompletionHandler({ (connection, anyObject, error) -> Void in
                
                if error != nil{
                    print("There was an error while querying facebook! \(error)")
                    return
                }
                
                //print(connection)
                print(anyObject)
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

