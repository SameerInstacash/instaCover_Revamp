//
//  FaqQuestionTblCell.swift
//  InstaCover
//
//  Created by Sameer Khan on 10/08/21.
//

import UIKit

class FaqQuestionTblCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var lblNum: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var btnPlusMinus: UIButton!

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
