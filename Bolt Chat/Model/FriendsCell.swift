//
//  FriendsCell.swift
//  Bolt Chat
//
//  Created by Bob Yuan on 2019/8/20.
//  Copyright © 2019 Bob Yuan. All rights reserved.
//

import UIKit
import Firebase

protocol HandleSwitchDelegate {
    func switchPressed(uid: String, isOn: Bool)
}

class FriendsCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    var uid = ""
    
    
    var delegate : HandleSwitchDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchButton.isOn = false
    }

    @IBAction func switchPressed(_ sender: Any) {
        delegate?.switchPressed(uid: uid, isOn: switchButton.isOn)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
