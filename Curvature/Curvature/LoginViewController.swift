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
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        var ref = FIRDatabase.database().reference()
//        ref.authUser(self.emailTextField.text, password: self.passwordTextField.text, withCompletionBlock: { error, authData in
//            if error != nil {
//                print(error)
//            } else {
//                self.performSegue(withIdentifier: "loggedIn", sender: self)
//            }
//        })
        
        FIRAuth.auth()!.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { error, authData in
            
            if error != nil {
                print(error)
            } else {
                self.performSegue(withIdentifier: "loggedIn", sender: self)
            }
        })

    }
}
