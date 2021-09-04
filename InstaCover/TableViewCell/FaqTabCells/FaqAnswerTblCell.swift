//
//  FaqAnswerTblCell.swift
//  InstaCover
//
//  Created by Sameer Khan on 11/08/21.
//

import UIKit
import WebKit

class FaqAnswerTblCell: UITableViewCell, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var baseViewForWeb: UIView!
    @IBOutlet weak var webViewHeightConstraint : NSLayoutConstraint!
    
    var webView: WKWebView!
    
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
