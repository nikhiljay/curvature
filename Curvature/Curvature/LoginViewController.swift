//
//  LoginViewController.swift
//  Curvature
//
//  Created by Nikhil D'Souza on 5/8/16.
//  Copyright © 2016 Nikhil D'Souza. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let ref = Firebase(url: "https://curvatureapp.firebaseio.com")
        ref.authUser(self.emailTextField.text, password: self.passwordTextField.text, withCompletionBlock: { error, authData in
            if error != nil {
                print(error)
            } else {
                self.performSegueWithIdentifier("loggedIn", sender: self)
            }
        })
    }
}
