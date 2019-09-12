//
//  FriendsViewController.swift
//  Bolt Chat
//
//  Created by Bob Yuan on 2019/8/20.
//  Copyright © 2019 Bob Yuan. All rights reserved.
//

import UIKit
import Firebase

class FriendsViewController: UITableViewController, HandleSwitchDelegate {
    func switchPressed(uid: String, isOn: Bool) {
        
    }
    
    var newChatRoomUsersArray = [Array<Any>]()
    let uid = Auth.auth().currentUser?.uid
    var email = ""
    var username = ""
    
    var users = [User]()
    
    var chatNameIndex : String = ""
    var admin : Bool?
    
    override func viewDidLoad() {
        
        print("man 1")
        verifyUserAuthenticationState()
        
        print("man 2")
        retrieveUsersList()
        
        print("man 3")
        tableView.register(UINib(nibName: "FriendsCell", bundle: nil), forCellReuseIdentifier: "customFriendsCell")
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customFriendsCell", for: indexPath) as! FriendsCell
        
        cell.emailLabel.text = users[indexPath.row].email
        cell.usernameLabel.text = users[indexPath.row].name
        cell.uid = users[indexPath.row].uid
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row].name
        let fuid = users[indexPath.row].uid
        var isFollower = false
        chatNameIndex = user
        
        let friend = Database.database().reference().child("users").child(self.uid!).child("Friends")
        friend.observeSingleEvent(of: .value) {
            (snapshot) in
            print("hi 1")
            if let snapshotValue = snapshot.value as? [String: AnyObject] {
                print("hi 2")
                print(snapshotValue)
                for (key, value) in snapshotValue {
                    print(key)
                    print(self.username)
                    if key as! String == fuid {
                        isFollower = true
                        print("found duplicate!!")
                        print("isf: \(isFollower)")
                    }
                    if user == self.username{
                        isFollower = true
                        print("cannot follow yourself")
                    }
                    
                    if value as! String == "\(self.username)::\(user)" {
                        self.admin = true
                    }
                }
                
                
                
            }
            
            if isFollower == false {
                let alert = UIAlertController(title: "Add friend?", message: "do you want to add \(user)?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default))
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {
                    _ in
                    print("hi 3")
                    
                    
                    print("hi 4")
                    friend.child(fuid).setValue("\(self.username)::\(user)") {
                        (error, reference) in
                        if error != nil {
                            print(error)
                        }
                        else {
                            print("success 1")
                            
                            
                        }
                    }
                    
                    Database.database().reference().child("users").child(fuid).child("Friends").child(self.uid!).setValue("\(self.username)::\(user)") {
                        (error, reference) in
                        if error != nil {
                            print(error)
                        }
                        else {
                            print("success 2")
                            
                            
                        }
                    }
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.performSegue(withIdentifier: "startChat", sender: self)
            }
            
        }
        
        print("isf+: \(isFollower)")
        
        
        

        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startChat" {
            let chatVC = segue.destination as! ChatViewController
            print("chatnameinux: \(chatNameIndex)")
            chatVC.chatRoom = chatNameIndex
            chatVC.myName = username
            chatVC.whoisAdmin = admin
            
        }
    }
    
    func retrieveUsersList() {
        Database.database().reference().child("users").observe(.childAdded) {
            (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            let user = User()
            
            print(snapshotValue)
            
            user.name = snapshotValue["Name"]! as! String
            user.email = snapshotValue["Email"]! as! String
            user.uid = snapshot.key
            
            self.users.append(user)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }
    }
    
    func verifyUserAuthenticationState() {
        if Auth.auth().currentUser?.uid == nil {
            print("user not logged in...")
            navigationController?.popViewController(animated: true)
        }
        else {
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: {
                (snapshot) in
                
                print(snapshot)
                let snapshotValue = snapshot.value as! Dictionary<String, Any>
                let name = snapshotValue["Name"]
                let email = snapshotValue["Email"]
                print("ok 1")
                
                
                self.username = name as! String
                self.navigationItem.title = name as! String
                
            }, withCancel: nil)
        }
    }
    
}
