//
//  AccountItemTblCell.swift
//  InstaCover
//
//  Created by Sameer Khan on 06/08/21.
//

import UIKit

class AccountItemTblCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var lblItemName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        UIView.addShadowOnView(baseView: self.baseView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
