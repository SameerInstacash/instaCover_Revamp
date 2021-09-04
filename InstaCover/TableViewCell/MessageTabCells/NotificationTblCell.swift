//
//  NotificationTblCell.swift
//  InstaCover
//
//  Created by Sameer Khan on 06/08/21.
//

import UIKit

class NotificationTblCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var iconImageVW: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
