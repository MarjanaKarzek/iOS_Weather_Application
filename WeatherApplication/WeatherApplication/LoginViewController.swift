//
//  LoginViewController.swift
//  WeatherApplication
//
//  Created by Marjana on 07.08.17.
//  Copyright © 2017 Marjana Karzek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passwordInputBegin(_ sender: Any) {
        if usernameField.text != "" {
            signInButton.isEnabled = true
        }
    }
    
    @IBAction func passwordInputEnd(_ sender: Any) {
        if usernameField.text != "" && passwordField.text != "" {
            signInButton.isEnabled = true
        }
    }
    
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

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showHome" {
            if usernameField.text != "" && passwordField.text != "" {
                let password = DBManager.shared.showPasswordFor(usernameInput: usernameField.text ?? "")
                if password == passwordField.text {
                    return true
                } else {
                    showToast(message: "incorrect")
                    signInButton.isEnabled = false
                    passwordField.text = ""
                    return false
                }
            } else {
                showToast(message: "incomplete")
                signInButton.isEnabled = false
                return false
            }
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

}
