//
//  CustomerRequestTblCell.swift
//  InstaCover
//
//  Created by Sameer Khan on 09/08/21.
//

import UIKit

class CustomerRequestTblCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStatusDetails: UILabel!
    @IBOutlet weak var lblServiceID: UILabel!
    @IBOutlet weak var lblRefund: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnCreateServiceRequest: UIButton!

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
