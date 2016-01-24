//
//  DetailViewController.swift
//  MissBizBB
//
//  Created by MiciH on 1/24/16.
//  Copyright © 2016 MicahelH. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {
    
    var name = ""
    var image = UIImage()
    

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var pictureView: UIImageView!
    
    @IBAction func fbButt(sender: AnyObject) {
        
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
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(animated: Bool) {
        
        pictureView.layer.cornerRadius = 10
        pictureView.clipsToBounds = true

        nameLabel.text = name
        pictureView.image = image
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
