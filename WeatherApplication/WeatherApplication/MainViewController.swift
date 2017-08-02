//
//  MainViewController.swift
//  WeatherApplication
//
//  Created by Marjana Karzek on 02/08/17.
//  Copyright © 2017 Marjana Karzek. All rights reserved.
//

import UIKit
import Social

private var testimages = ["testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg"]

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func facbookButtonPushed(sender: UIButton){
        let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookSheet.setInitialText("This is the weather for the next 10 days")
        for imagetitle in testimages{
            facebookSheet.add(UIImage(named: imagetitle))
        }
        self.present(facebookSheet, animated:true, completion:nil)
    }
    
    @IBAction func twitterButtonPushed(sender: UIButton) {
        let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        twitterSheet.setInitialText("This is the weather for the next 10 days")
        for imagetitle in testimages{
            twitterSheet.add(UIImage(named: imagetitle))
        }
        self.present(twitterSheet, animated: true, completion: nil)
    }
}
