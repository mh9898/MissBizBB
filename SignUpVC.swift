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
        
        var urlArray = ["https://tangentlabs-nailsinc-prod.s3.amazonaws.com/cache/21/c2/21c2974d2b3b36713a5cecafe65dc3f8.jpg",
            "https://tangentlabs-nailsinc-prod.s3.amazonaws.com/cache/e9/1f/e91fd242affdfcbbb6e1eaaefc16f2e9.jpg",
            "https://tangentlabs-nailsinc-prod.s3.amazonaws.com/cache/ce/ff/ceff3c89d6a8608725ad029097e907f7.jpg",
            "https://scontent.cdninstagram.com/hphotos-xpf1/t51.2885-15/s640x640/sh0.08/e35/12530723_1729825740583091_1739270513_n.jpg",
            "https://scontent.cdninstagram.com/hphotos-xtp1/t51.2885-15/s640x640/sh0.08/e35/12627849_869163899871391_144609289_n.jpg",
            "https://tangentlabs-nailsinc-prod.s3.amazonaws.com/cache/1e/01/1e01ce5a03fdcac91ac6f69dff61155f.jpg"
        ]
        
        var contuer = 1
        
        for url in urlArray {
            
            let nsUrl = NSURL(string: url)!
            print(nsUrl)
            
            if let data = NSData(contentsOfURL: nsUrl) {
                
                self.userImage.image = UIImage(data: data)
                
                let imageFile: PFFile = PFFile(data: data)!
                
                var user:PFUser = PFUser()
                
                let username = "user\(contuer)"
                
                user.username = username
                user.password = "pass"
                user["image"] = imageFile
                user["Manicure"] = true
                
                contuer++
                
                do{
                    
                    try user.signUp()
                }
                catch{
                    print(error)
                }

            }
        }

        
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
        }
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
