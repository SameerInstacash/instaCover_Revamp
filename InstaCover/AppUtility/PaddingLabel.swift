//
//  PaddingLabel.swift
//  TechCheck Exchange
//
//  Created by Sameer Khan on 24/07/21.
//

import UIKit

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}

@IBDesignable class ReverseGradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = [UIColor().HexToColor(hexString: AppSecondThemeColorHexString).cgColor, UIColor().HexToColor(hexString: AppFirstThemeColorHexString).cgColor]
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
}


@IBDesignable class GradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = [UIColor().HexToColor(hexString: AppFirstThemeColorHexString).cgColor, UIColor().HexToColor(hexString: AppSecondThemeColorHexString).cgColor]
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
}

@IBDesignable class GradientButton: UIButton {
    
    private var gradientLayer: CAGradientLayer!
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = [UIColor().HexToColor(hexString: "#58BDF6").cgColor, UIColor().HexToColor(hexString: "#69e0db").cgColor]
        
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
}

@IBDesignable class CornerButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
}

class DesignManager: NSObject {
    
    class func loadViewControllerFromMainStoryBoard(identifier: String) -> Any {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
    class func loadViewControllerFromDashboardStoryBoard(identifier: String) -> Any {
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
    class func loadViewControllerFromHomeStoryBoard(identifier: String) -> Any {
        let storyBoard = UIStoryboard(name: "Home", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
    class func loadViewControllerFromFaqStoryBoard(identifier: String) -> Any {
        let storyBoard = UIStoryboard(name: "Faq", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
    class func loadViewControllerFromMessageStoryBoard(identifier: String) -> Any {
        let storyBoard = UIStoryboard(name: "Message", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
    class func loadViewControllerFromAccountStoryBoard(identifier: String) -> Any {
        let storyBoard = UIStoryboard(name: "Account", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        return controller
    }

    class func loadViewControllerFromInstacashSDKStoryBoard(identifier: String) -> Any {
        let storyBoard = UIStoryboard(name: "InstaCashSDK", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
    class func gradientColor(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
    //We are creating UIImage to get gradient color.
          UIGraphicsBeginImageContext(gradientLayer.bounds.size)
          gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
          let image = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          return UIColor(patternImage: image!)
    }
    
    class func getGradientLayer(bounds : CGRect) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }

    
}
