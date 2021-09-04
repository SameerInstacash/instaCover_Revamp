//
//  MessageTabVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit

class MessageTabVC: UIViewController, CAPSPageMenuDelegate {

    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUIElements()
    }
  
    //MARK: Custom Method
    func setUIElements() {
        self.setStatusBarGradientColor()
        
        self.setUpPageMenu()
    }
    
    //MARK: CSPage Menu
    func setUpPageMenu() {
        //////..........CSPAGEMENU........../////
        var controllerArray : [UIViewController] = []
        
        let controller1 = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        controller1.title = "Contact us"
        controllerArray.append(controller1)
        
        let controller2 = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        controller2.title = "Notification"
        controllerArray.append(controller2)
                
        // Customize menu (Optional)
        let parameters  = [
            
            CAPSPageMenuOptionScrollMenuBackgroundColor : UIColor.clear,
            CAPSPageMenuOptionViewBackgroundColor : UIColor.clear,
            CAPSPageMenuOptionSelectionIndicatorColor : #colorLiteral(red: 0.4117647059, green: 0.8784313725, blue: 0.8588235294, alpha: 1),
            CAPSPageMenuOptionSelectedMenuItemLabelColor : #colorLiteral(red: 0.4117647059, green: 0.8784313725, blue: 0.8588235294, alpha: 1),
            CAPSPageMenuOptionUnselectedMenuItemLabelColor:UIColor.gray,
            CAPSPageMenuOptionBottomMenuHairlineColor : UIColor.white,
            CAPSPageMenuOptionMenuItemFont : UIFont(name: AppFontSemiBold, size: 18.0)!,
                        
            CAPSPageMenuOptionMenuItemWidthBasedOnTitleTextWidth : false,
            CAPSPageMenuOptionCenterMenuItems : true,
            CAPSPageMenuOptionScrollAnimationDurationOnMenuItemTap : true,
            
    
            CAPSPageMenuOptionMenuHeight : 50.0,
            //CAPSPageMenuOptionMenuItemWidth : 200.0,
            CAPSPageMenuOptionUseMenuLikeSegmentedControl : true,
            CAPSPageMenuOptionSelectionIndicatorHeight : 2.0,
            CAPSPageMenuOptionMenuItemSeparatorWidth : 1.0,
            CAPSPageMenuOptionEnableHorizontalBounce : true
            ] as [String : Any]
        
        
        // Initialize scroll menu
        var topHeight:CGFloat = 64.0
    
        if UIDevice().userInterfaceIdiom == .phone {
            
            switch UIScreen.main.nativeBounds.height {
            case 1136.0:
                // iphone 5,iphone 5c,iphone 5s,iphone SE
                topHeight = 20.0
            case 1334.0:
                // iphone 6,iphone 6+,iphone 6s,iphone 7,iphone 8
                topHeight = 20.0
            case 1792.0:
                // iphone XR,iphone 11
                topHeight = 44.0
            case 1920.0:
                // iphone 6s+,iphone 7+,iphone 8+
                topHeight = 20.0
            case 2436.0:
                // iphone X,iphone XS,iphone 11 pro
                topHeight = 44.0
            default:
                // iphone XS Max,iphone 11 pro Max
                topHeight = 44.0
            }
            
        }
        
        //pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: topHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - topHeight ), options: parameters)
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: topHeight, width: self.view.frame.size.width, height: self.view.frame.size.height), options: parameters)
        pageMenu?.delegate = self
        self.view.addSubview(self.pageMenu!.view)
        self.addChild(self.pageMenu!)
        self.willMove(toParent: self.pageMenu)
        
    }
    
    //MARK : CSPageMenu Delegates
    func willMove(toPage controller: UIViewController!, index: Int) {
        //print(controller,index)
    }
    
    func didMove(toPage controller: UIViewController!, index: Int) {
        //print(controller,index)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
