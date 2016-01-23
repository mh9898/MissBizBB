//
//  ManicureVC.swift
//  MissBizBB
//
//  Created by MiciH on 1/23/16.
//  Copyright © 2016 MicahelH. All rights reserved.
//

import UIKit
import Parse

class ManicureVC: UIViewController {
    
    var intestedIn = ""
    
    var displayedUserId = ""

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var swipeResult: UILabel!
    
    @IBAction func logOut(sender: AnyObject) {
        
    }
    
    
    func wasDragged(gesture : UIPanGestureRecognizer) {
        
        //FOLLWING THE LABEL
        let translation = gesture.translationInView(self.view)
        
        //get the label form the panGesture
        let label = gesture.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        //DECRASING THE LABEL SIZE ON ROTATION
        //traking the number of pix from the center
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        let scale = min (100 / abs(xFromCenter),1) // 1 or samller
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)//1 = 60deg
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        //CENTER ON RELESE
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            
            //Mid left
            if label.center.x < 100 {
                print("Not chosen" + displayedUserId)//label.center.x
                
                acceptedOrRejected = "rejected"
            }
                //Right
            else if label.center.x > self.view.bounds.width - 100 {
                print("Chosen")
                
                acceptedOrRejected = "accepted"
            }
            
            if acceptedOrRejected != "" {
                
                PFUser.currentUser()?.addUniqueObjectsFromArray([displayedUserId], forKey: acceptedOrRejected)
                
                do{
                    try PFUser.currentUser()?.save()
                }
                catch{
                    print(error)
                }

                
            }
            
            
            
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            label.transform = stretch
            label.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height / 2)
            
            updateImage()
            
        }
    }

    func updateImage(){
        
        
        let query = PFUser.query()
        
        if (PFUser.currentUser()?["Manicure"])! as! Bool == true {
            
            intestedIn = "manicure"
        }
        query?.whereKey("Professional", equalTo: "manicure")
        
        if let acceptedUsers = PFUser.currentUser()?["accepted"] {
            
            query?.whereKey("objectId", notContainedIn: acceptedUsers as! Array)
            
        }
        
        if let rejectedUsers = PFUser.currentUser()?["rejected"] {
            
            query?.whereKey("objectId", notContainedIn: rejectedUsers as! Array)
            
        }
        
        
        query?.limit = 1
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if error != nil{
                
                print(error)
            }
            else if let objects = objects {
                
                for object in objects {
                    
                    self.displayedUserId = object.objectId!
                    
                    let imageFile = object["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                        
                        if error != nil {
                            
                            print(error)
                        }
                            
                        else{
                            
                            if let data = imageData {
                                
                                self.userImage.image = UIImage(data: data)
                            }
                            
                        }
                        
                    })
                }
                
            }
        })

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        userImage.addGestureRecognizer(gesture)
        
        userImage.userInteractionEnabled = true
        
        updateImage()
        
        userImage.layer.cornerRadius = 10
        userImage.clipsToBounds = true
        
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logoutSegue" {
            
            PFUser.logOut()
        }
        // Pass the selected object to the new view controller.
    }
    

}
