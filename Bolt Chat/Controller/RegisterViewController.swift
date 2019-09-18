//
//  RegisterViewController.swift
//  Bolt Chat
//
//  Created by Bob Yuan on 2019/8/4.
//  Copyright © 2019 Bob Yuan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChat" {
            let chatRoomVC = segue.destination as! ChatRooomController
            chatRoomVC.hasFriends = false
            chatRoomVC.hasChatRooms = false
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
            (result,error) in
            if error != nil {
                print(error)
            }
            else {
                
                let userRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
                let values = ["Name": self.usernameTextField.text, "Email": self.emailTextField.text, "Pass": self.passwordTextField.text]
                userRef.setValue(values) {
                    (error, reference) in
                    if error != nil {
                        print(error)
                    }
                    else {
                        print("Registered a new user!")
                        self.performSegue(withIdentifier: "goToChat", sender: self)
                    }
                }
                
                
                
                
            }
            
            
        })
    }
    
}
