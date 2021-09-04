//
//  Color.swift
//  InstaCashSDK
//
//  Created by Sameer Khan on 06/07/21.
//

import UIKit

extension UIColor
{
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor
    {
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt64
    {
        var hexInt: UInt64 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt64(&hexInt)
        return hexInt
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
}

@IBDesignable class cornerView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
}

extension UIView {
   
    //to add Shadow and Radius On desired UIView
    static func addShadow(baseView: UIView) {
        baseView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50).cgColor
        baseView.layer.shadowOffset = CGSize.init(width: 0.0, height: 1.2)
        baseView.layer.shadowOpacity = 1.0
        baseView.layer.shadowRadius = 1.5
        baseView.layer.masksToBounds = false
    }
    
    //to add 4 side Shadow and Radius On desired UIView
    static func addShadowOn4side(baseView: UIView) {
        let shadowSize : CGFloat = 3.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,y: -shadowSize / 2,width: baseView.frame.size.width + shadowSize,height: baseView.frame.size.height + shadowSize))
        baseView.layer.masksToBounds = false
        baseView.layer.shadowColor = UIColor.darkGray.cgColor
        baseView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        baseView.layer.shadowOpacity = 0.5
        baseView.layer.shadowPath = shadowPath.cgPath
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        //mask.frame = bounds
        mask.path = path.cgPath
        layer.mask = mask
        //mask.masksToBounds = true
    }
    
    static func addShadowOnViewGray(baseView: UIView) {
        baseView.layer.cornerRadius = 5.0
        baseView.layer.shadowColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1).cgColor
        baseView.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        baseView.layer.shadowOpacity = 1.0
        baseView.layer.shadowRadius = 5.0
        baseView.layer.masksToBounds = false
    }
    
    static func addShadowOnViewThemeColor(baseView: UIView) {
        baseView.layer.cornerRadius = 5.0
        baseView.layer.shadowColor = #colorLiteral(red: 0.4239478707, green: 0.8932834268, blue: 0.909252286, alpha: 1).cgColor
        baseView.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        baseView.layer.shadowOpacity = 1.0
        baseView.layer.shadowRadius = 5.0
        baseView.layer.masksToBounds = false
    }
    
    static func addShadowOnView(baseView: UIView) {
        baseView.layer.cornerRadius = 10.0
        baseView.layer.shadowColor = #colorLiteral(red: 0.4239478707, green: 0.8932834268, blue: 0.909252286, alpha: 1).cgColor
        baseView.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        baseView.layer.shadowOpacity = 0.5
        baseView.layer.shadowRadius = 10.0
        baseView.layer.masksToBounds = false
    }
    
}

extension StringProtocol { // for Swift 4 you need to add the constrain `where Index == String.Index`
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}
