//
//  CreateChatRoomController.swift
//  Bolt Chat
//
//  Created by Bob Yuan on 2019/8/25.
//  Copyright © 2019 Bob Yuan. All rights reserved.
//

import UIKit
import Firebase

class CreateChatRoomController: UIViewController {
    
    @IBOutlet weak var chatRoomNameTextField: UITextField!
    
    let myUid = Auth.auth().currentUser?.uid
    
    var usersListFromPreviousController = Array<String>()
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func createPressed(_ sender: Any) {
        addChatRoomToDB()
        performSegue(withIdentifier: "letsChat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "letsChat" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.chatRoomURL = chatRoomNameTextField.text!
            chatVC.isChatRoom = true
        }
    }
    
    func addChatRoomToDB() {
        let chatRooms = Database.database().reference().child("chatRooms")
        let usersSection = Database.database().reference().child("users")
        chatRooms.child(chatRoomNameTextField.text!).child("users").setValue(usersListFromPreviousController) {
            (error, reference) in
            
            if error != nil {
                print(error)
            }
            else {
                print("success!")
            }
            
        }
        
        for users in usersListFromPreviousController {
            if users == myUid {
                print("heee")
                
                DispatchQueue.main.async {
                    usersSection.child(users).child("chatrooms").child(self.chatRoomNameTextField.text!).setValue("A")
                }
            }
            else {
                DispatchQueue.main.async {
                    usersSection.child(users).child("chatrooms").child(self.chatRoomNameTextField.text!).setValue("M")
                }
            }
            
            
        }
        
    }
    
}
