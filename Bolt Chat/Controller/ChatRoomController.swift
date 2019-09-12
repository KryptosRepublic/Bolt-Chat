//
//  ChatRoomController.swift
//  Bolt Chat
//
//  Created by Bob Yuan on 2019/8/25.
//  Copyright © 2019 Bob Yuan. All rights reserved.
//

import UIKit
import Firebase

protocol changeChatTypeDelegate {
    func changeType(type: Bool, url: String)
}

class ChatRooomController: UITableViewController, HandleSwitchDelegate {

    let uid = Auth.auth().currentUser?.uid
    
    var delegate : changeChatTypeDelegate?
    
    var isChatRoom : Bool?
    var url : String?
    
    var users = [User]()
    var chatRoomMembers = Array<String>()
    
    //var users1 = ["lucy", "bob"]
    
    func switchPressed(uid: String, isOn: Bool) {
        print("switch pressed!")
        print(isOn)
        var alreadyMem = false
        if isOn == true {
            for mem in chatRoomMembers {
                if mem == uid {
                    print("already a member")
                    alreadyMem = true
                }
                if mem != uid {
                    alreadyMem = false
                }
                
            }
            print(alreadyMem)
            
            if alreadyMem != true {
                chatRoomMembers.append(uid)
            }
            
        }
        
        
        print(chatRoomMembers)
    }
    
    override func viewDidLoad() {
        
        
        retrieveFriends()
        retrieveChatRooms()
        tableView.register(UINib(nibName: "FriendsCell", bundle: nil), forCellReuseIdentifier: "customFriendsCell")
        setupNavBarItems()
        chatRoomMembers.append(uid!)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customFriendsCell", for: indexPath) as! FriendsCell
        
        cell.usernameLabel.text = users[indexPath.row].name
        cell.uid = users[indexPath.row].uid
        cell.delegate = self
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if users[indexPath.row].uid == "" {
            isChatRoom = true
            url = users[indexPath.row].name
            self.performSegue(withIdentifier: "goToChatVC", sender: self)
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewChatRoom" {
            let createRoomVC = segue.destination as! CreateChatRoomController
            print("preparing ...")
            createRoomVC.usersListFromPreviousController = chatRoomMembers
            print("sent list")
        }
        if segue.identifier == "goToChatVC" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.isChatRoom = isChatRoom
            chatVC.chatRoomURL = url!
        }
        
    }
    
    @objc func addTapped() {
        performSegue(withIdentifier: "goToUsers", sender: self)
    }
    
    @objc func createNewChatRoom() {
        print("prep 1")
        performSegue(withIdentifier: "createNewChatRoom", sender: self)
    }
    
    
    
    func setupNavBarItems() {
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped)), UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(createNewChatRoom))]
        
    }
    
    func retrieveChatRooms() {
        let rooms = Database.database().reference().child("users").child(uid!).child("chatrooms")
        rooms.observeSingleEvent(of: .value) {
            (snapshot) in
            
            let snapshotValue = snapshot.value as? [String: AnyObject]
            for (name, administration) in snapshotValue! {
                print(name)
                print(administration)
                let user = User()
                user.name = name
                user.uid = ""
                self.users.append(user)
            }
            
        }
    }
    
    
    func retrieveFriends() {
        let usersDB = Database.database().reference().child("users")
        let friends = Database.database().reference().child("users").child(uid!).child("Friends")

        friends.observe(.childAdded) {
            (snapshot) in
            let snapshotValue = snapshot.value as? [String: AnyObject]
            print("KEYYYYYY: \(snapshot.key)")
            
            let key = snapshot.key
            
            usersDB.child(key).observeSingleEvent(of: .value) {
                (snapshot) in
                
                let userSnapValue = snapshot.value as! Dictionary<String, Any>
                let user = User()
                
                let username = userSnapValue["Name"] as! String
            
                user.name = username
                user.uid = key
                self.users.append(user)
                
                print(self.users)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
}
