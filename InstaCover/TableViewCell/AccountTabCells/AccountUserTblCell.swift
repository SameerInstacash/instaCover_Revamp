//
//  AccountUserTblCell.swift
//  InstaCover
//
//  Created by Sameer Khan on 06/08/21.
//

import UIKit

class AccountUserTblCell: UITableViewCell {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var UserImageVW: UIImageView!    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
