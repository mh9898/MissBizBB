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


class SignUpVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var ManicureSwitch: UISwitch!
    
    @IBAction func logOut(sender: AnyObject) {
    
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func submit(sender: AnyObject) {
        
        PFUser.currentUser()?["Manicure"] = ManicureSwitch.on
        
        do{
            try PFUser.currentUser()?.save()
            
            let alert = UIAlertController(title: "Sucess", message: "Thank you for sumbiting", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
            
        catch{
            print(error)
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let garphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, gender"])
        garphRequest.startWithCompletionHandler {
            (connection, result, error) -> Void in
            
            if error != nil {
                
                print(error)
            }
            
            else if let result = result {
                //print(result)
            
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
                
                let FBProfilePicturesUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                
                    if let fbpicUrl = NSURL(string: FBProfilePicturesUrl) {
                    
                        if let data = NSData(contentsOfURL: fbpicUrl) {
                            
                            self.userImage.image = UIImage(data: data)
                            
                            let imageFile:PFFile = PFFile(data: data)!
                            
                            PFUser.currentUser()?["image"] = imageFile
                            
                            do{
                                try PFUser.currentUser()?.save()
                            }
                            catch{
                                print(error)
                            }

                        }
                    }
            }
            
        }

        // Do any additional setup after loading the view.
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
