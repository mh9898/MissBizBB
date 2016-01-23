//
//  SignUpVC.swift
//  MissBizBB
//
//  Created by MiciH on 1/15/16.
//  Copyright © 2016 MicahelH. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import Social


class SignUpVC: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var ManicureSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestParameters = ["fields": "id, email, name, gender"]
        
        let garphRequest = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        garphRequest.startWithCompletionHandler {
            (connection, result, error) -> Void in
            
            if error != nil {
                
                print(error)
            }
            
            else if let result = result {
                //print(result)
                
                PFUser.currentUser()?["fbid"] = result["id"]
                PFUser.currentUser()?["name"] = result["name"]
                PFUser.currentUser()?["email"] = result["email"]
                PFUser.currentUser()?["gender"] = result["gender"]
                
                do{
                    try PFUser.currentUser()?.save()
                }
                catch{
                    print(error)
                }
                
                let userId = result["id"] as! String
                print(userId)
                
                
                let FBProfilePicturesUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                    
                    if let fbpicUrl = NSURL(string: FBProfilePicturesUrl) {
                        
                        self.userImage.sd_setImageWithURL(fbpicUrl)
                    }
                        //maybe the imageview is during download, so cancel the download
                        else{
                           self.userImage.sd_cancelCurrentImageLoad()
                            self.userImage.image = nil
                        }
            }
            
        }

    }
    
    @IBAction func fbButt() {
        
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            
            let fbSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbSheet.addURL(NSURL(string: "http://www.missbeez.com/"))
            
            presentViewController(fbSheet, animated: true, completion: nil)
        }
            
        else{
            
            let alert = UIAlertController(title: "FB Setup", message: "Please login to your FaceBook account in setting", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
//            self.performSegueWithIdentifier("loginManicure", sender: AnyObject?)
        }
    }
    
   
    
    
    @IBAction func submit(sender: AnyObject) {
        
        PFUser.currentUser()?["Manicure"] = ManicureSwitch.on
        
        do{
            try PFUser.currentUser()?.save()
            
            let alert = UIAlertController(title: "Sucess", message: "Thank you for sumbiting", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.performSegueWithIdentifier("manicureSegue", sender: self)})
            
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
            
            
        catch{
            print(error)
        }
        
       
    }
    
        @IBAction func logOut(sender: AnyObject) {
        
        PFUser.logOut()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
