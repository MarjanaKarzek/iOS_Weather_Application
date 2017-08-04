//
//  ProfileViewController.swift
//  WeatherApplication
//
//  Created by Marjana Karzek on 02/08/17.
//  Copyright © 2017 Marjana Karzek. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var homelocationField: UITextField!
    @IBOutlet weak var previewAmountField: UITextField!
    var defaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            defaults = delegate.defaults
        }
        
        let usernameValue = defaults.string(forKey: "WeatherApp_username")
        usernameField.text = usernameValue
        
        let homelocationValue = defaults.string(forKey: "WeatherApp_homelocation")
        homelocationField.text = homelocationValue
        
        let previewAmountValue = defaults.integer(forKey: "WeatherApp_previewAmount")
        if previewAmountValue != 0{
            previewAmountField.text = "\(previewAmountValue)"
        }else{
            previewAmountField.text = "10"
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editingUsernameEnd(_ sender: Any) {
        defaults.set(usernameField.text, forKey: "WeatherApp_username")
    }
    
    @IBAction func editingHomelocationEnd(_ sender: Any) {
        defaults.set(homelocationField.text, forKey: "WeatherApp_homelocation")
    }
    
    @IBAction func editingPreviewAmountEnd(_ sender: Any) {
        defaults.set(previewAmountField.text, forKey: "WeatherApp_previewAmount")
        if previewAmountField.text == "" {
            previewAmountField.text = "10"
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
