//
//  AccountViewController.swift
//  Curvature
//
//  Created by Nikhil D'Souza on 5/7/16.
//  Copyright © 2016 Nikhil D'Souza. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createButtonPressed(_ sender: AnyObject) {
        var ref = FIRDatabase.database().reference()
        ref.createUser(emailTextField.text, password: passwordTextField.text, withValueCompletionBlock: { error, result in
            if error != nil {
                print(error)
            } else {
                let uid = result?["uid"] as? String
                print("Successfully created user account with uid: \(uid!)")
                
                ref?.authUser(self.emailTextField.text, password: self.passwordTextField.text, withCompletionBlock: { error, authData in
                    if error != nil {
                        print(error)
                    } else {
                        self.performSegue(withIdentifier: "accountCreated", sender: self)
                        
                        let newUser = [
                            "name" : self.nameTextField.text as AnyObject!,
                            "condition" : "Unknown" as AnyObject!,
                            "taskCompletion" : 0 as AnyObject!,
                            "tasks" : [
                                "surveyKnowledge" : false,
                                "surveyBackground" : false,
                                "picture" : false,
                                "bend" : false
                            ] as AnyObject!
                        ]

                        ref?.child(byAppendingPath: "users").child(byAppendingPath: authData?.uid).setValue(newUser)
                    }
                })
            }
        })
    }
}
