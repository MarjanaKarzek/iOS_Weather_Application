//
//  SignUpViewController.swift
//  WeatherApplication
//
//  Created by Marjana on 07.08.17.
//  Copyright © 2017 Marjana Karzek. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCheckField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passwordCheckEditingBegin(_ sender: Any) {
        if usernameField.text != "" && passwordField.text != "" {
            signUpButton.isEnabled = true
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showHome" {
            if usernameField.text == "" || passwordField.text == "" || passwordCheckField.text == "" {
                showToast(message: "incomplete")
            } else if passwordField.text != passwordCheckField.text {
                showToast(message: "passwords wrong")
            } else {
                let result = DBManager.shared.insertUser(usernameInput: usernameField.text!, passwordInput: passwordField.text!)
                if result == nil {
                    showToast(message: "not unique user")
                } else {
                    if let delegate = UIApplication.shared.delegate as? AppDelegate {
                        delegate.loggedOnUserID = result!
                    }
                    return true
                }
            }
            return false
        }
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func showToast(message: String) {
        let toast = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toast.textColor = UIColor.white
        toast.textAlignment = .center;
        toast.text = message
        toast.alpha = 1.0
        toast.layer.cornerRadius = 10;
        toast.clipsToBounds  =  true
        self.view.addSubview(toast)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toast.alpha = 0.0
        }, completion: {(isCompleted) in
            toast.removeFromSuperview()
        })
    }
}
