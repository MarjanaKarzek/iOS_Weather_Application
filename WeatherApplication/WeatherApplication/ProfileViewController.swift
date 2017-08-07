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
    
    //var defaults = UserDefaults()
    var userID:Int64 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            //defaults = delegate.defaults
            userID = delegate.loggedOnUserID
        }
        
        /*let usernameValue = defaults.string(forKey: "WeatherApp_username")
        usernameField.text = usernameValue
        
        let homelocationValue = defaults.string(forKey: "WeatherApp_homelocation")
        homelocationField.text = homelocationValue
        
        let previewAmountValue = defaults.integer(forKey: "WeatherApp_previewAmount")
        if previewAmountValue != 0{
            previewAmountField.text = "\(previewAmountValue)"
        }else{
            previewAmountField.text = "10"
        }*/
        
        if let user = DBManager.shared.showUserBy(idInput: userID) {
            usernameField.text = user.name
            homelocationField.text = user.homelocation
            if user.previewAmount < 1 || user.previewAmount > 16 {
                previewAmountField.text = "10"
            } else {
                previewAmountField.text = ("\(user.previewAmount)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editingUsernameEnd(_ sender: Any) {
        //defaults.set(usernameField.text, forKey: "WeatherApp_username")
        DBManager.shared.updateUserNameBy(idInput: userID, nameInput: usernameField.text ?? "")
    }
    
    @IBAction func editingHomelocationEnd(_ sender: Any) {
        //defaults.set(homelocationField.text, forKey: "WeatherApp_homelocation")
        DBManager.shared.updateUserHomelocationBy(idInput: userID, homelocationInput: homelocationField.text ?? "")
    }
    
    @IBAction func editingPreviewAmountEnd(_ sender: Any) {
        //defaults.set(previewAmountField.text, forKey: "WeatherApp_previewAmount")
        if let previewAmount = Int64(previewAmountField.text ?? "10") {
            if(previewAmount < 1 || previewAmount > 16) {
                DBManager.shared.updateUserPreviewAmountBy(idInput: userID, previewAmountInput: 10)
                previewAmountField.text = "10"
            } else {
                DBManager.shared.updateUserPreviewAmountBy(idInput: userID, previewAmountInput: previewAmount)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLogin" {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.loggedOnUserID = Int64(0)
            }
        }
    }
    
}
