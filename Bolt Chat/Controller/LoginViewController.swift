//
//  LoginViewController.swift
//  Bolt Chat
//
//  Created by Bob Yuan on 2019/8/4.
//  Copyright © 2019 Bob Yuan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import TransitionButton

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.borderStyle = .roundedRect
        passwordTextField.borderStyle = .roundedRect
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
            (user, error) in
            if error != nil {
                print(error)
            }
            else {
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        })
    }
    
    

}
