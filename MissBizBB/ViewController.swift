//
//  ViewController.swift
//  MissBizBB
//
//  Created by MiciH on 1/15/16.
//  Copyright © 2016 MicahelH. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func FBButtonTapped(sender: AnyObject) {
        
        let permissions = ["public_profile","email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions){
            (user:PFUser?, error:NSError?) -> Void in
            
                if let error = error {
                    print(error)
                }
                else{
                    if let user = user {
                        self.performSegueWithIdentifier("ShowSgininScreen", sender: self)
                    }
                    
                }
        
            }
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        PFUser.logOut()
        
        //if user exsit log in automaticlly
        if let username = PFUser.currentUser()?.username{
            
            performSegueWithIdentifier("ShowSgininScreen", sender: self)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

