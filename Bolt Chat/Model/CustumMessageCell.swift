//
//  CustumMessageCell.swift
//  Bolt Chat
//
//  Created by Bob Yuan on 2019/8/4.
//  Copyright © 2019 Bob Yuan. All rights reserved.
//

import UIKit

class CustumMessageCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageTextView: UILabel!    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
