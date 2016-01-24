//
//  MyFBPageViewController.swift
//  MissBizBB
//
//  Created by MiciH on 1/17/16.
//  Copyright © 2016 MicahelH. All rights reserved.
//

import UIKit

class MyFBPageViewController: UIViewController {

    @IBAction func back(sender: AnyObject) {
       
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    @IBAction func youTube(sender: AnyObject) {
        
        let url = NSURL(string: "https://www.youtube.com/watch?v=Of9LPT_tRXU")
        
        let request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
    }
   
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "fb://profile")
        
        let request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
        
        
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
