//
//  ChatViewController.swift
//  Bolt Chat
//
//  Created by Bob Yuan on 2019/8/4.
//  Copyright © 2019 Bob Yuan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, changeChatTypeDelegate {
    func changeType(type: Bool, url: String) {
        isChatRoom = type
        chatRoomURL = url
    }
    

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputField: UITextField!

    var messagesArray = [Message]()
    var chatRoom = ""
    var myName = ""
    var chatRoomURL = ""
    var whoisAdmin : Bool?
    var isChatRoom : Bool?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustumMessageCell
        cell.senderLabel.layer.cornerRadius = 8.0
        cell.messageTextView.text = messagesArray[indexPath.row].text
        cell.senderLabel.text = messagesArray[indexPath.row].sender
        cell.imageView?.image = UIImage(named: "user")
        if cell.senderLabel.text == Auth.auth().currentUser?.email {
            cell.messageTextView.backgroundColor = .cyan
            cell.senderLabel.backgroundColor = .cyan
        }
        
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
        tableView.separatorStyle = .none
        
    }
    
    func handleSend() {
        if isChatRoom != true {
            let ref = Database.database().reference().child("chatRooms").child(chatRoomURL)
            print(ref)
            let values = ["text": inputField.text!, "name": Auth.auth().currentUser?.email!]
            inputField.text = ""
            ref.childByAutoId().setValue(values) {
                (error, reference) in
                if error != nil {
                    print(error)
                    print(reference)
                    print(ref)
                }
                else {
                    print("success!")
                }
            }
        }
        else {
            let ref = Database.database().reference().child("chatRooms").child(chatRoomURL).child("messages")
            print(ref)
            let values = ["text": inputField.text!, "name": Auth.auth().currentUser?.email!]
            inputField.text = ""
            ref.childByAutoId().setValue(values) {
                (error, reference) in
                if error != nil {
                    print(error)
                    print(reference)
                    print(ref)
                }
                else {
                    print("success!")
                }
            }
        }
        
        
    }
    
    func observeDBChange() {
        if isChatRoom != true {
            let ref = Database.database().reference().child("chatRooms").child(chatRoomURL)
            ref.observe(.childAdded) {
                (snapshot) in
                print(snapshot)
                
                let snapshotValue = snapshot.value as! Dictionary<String, String>
                let sender = snapshotValue["name"]
                let text = snapshotValue["text"]
                
                let message = Message()
                message.sender = sender
                message.text = text
                
                self.messagesArray.append(message)
                self.tableView.reloadData()
            }
        }
        else {
            let ref = Database.database().reference().child("chatRooms").child(chatRoomURL).child("messages")
            ref.observe(.childAdded) {
                (snapshot) in
                print(snapshot)
                
                let snapshotValue = snapshot.value as! Dictionary<String, String>
                let sender = snapshotValue["name"]
                let text = snapshotValue["text"]
                
                let message = Message()
                message.sender = sender
                message.text = text
                
                self.messagesArray.append(message)
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        if isChatRoom != true {
            if whoisAdmin == true {
                chatRoomURL = "\(myName)::\(chatRoom)"
            }
            else {
                chatRoomURL = "\(chatRoom)::\(myName)"
            }
        }
        
        configureTableView()
        
        observeDBChange()
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        handleSend()
    }
    
}
