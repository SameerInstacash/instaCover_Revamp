//
//  HomeAboutCVCell.swift
//  InstaCover
//
//  Created by Sameer Khan on 10/08/21.
//

import UIKit

class HomeAboutCVCell: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var aboutIconImgView: UIImageView!
    @IBOutlet weak var lblAboutTitle: UILabel!
    @IBOutlet weak var lblAboutSubTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        UIView.addShadowOnView(baseView: self.baseView)
    }

}
