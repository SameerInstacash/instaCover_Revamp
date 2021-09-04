//
//  TabBarViewController.swift
//  Medicus
//
//  Created by Jitendra Singh on 22/03/18.
//  Copyright © 2018 Jitendra Singh. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var selecIndexTab = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.tabBar.shadowImage = UIImage()
        
        if UIDevice().userInterfaceIdiom == .phone {
            
            switch UIScreen.main.nativeBounds.height {
            case 1136.0:
                // iphone 5,iphone 5c,iphone 5s,iphone SE
                self.tabBar.backgroundImage = #imageLiteral(resourceName: "smallNav")
            case 1334.0:
                // iphone 6,iphone 6+,iphone 6s,iphone 7,iphone 8
                self.tabBar.backgroundImage = #imageLiteral(resourceName: "smallNav")
            case 1792.0:
                // iphone XR,iphone 11
                self.tabBar.backgroundImage = #imageLiteral(resourceName: "bigNav")
            case 1920.0:
                // iphone 6s+,iphone 7+,iphone 8+
                self.tabBar.backgroundImage = #imageLiteral(resourceName: "smallNav")
            case 2436.0:
                // iphone X,iphone XS,iphone 11 pro
                self.tabBar.backgroundImage = #imageLiteral(resourceName: "bigNav")
            default:
                // iphone XS Max,iphone 11 pro Max
                self.tabBar.backgroundImage = #imageLiteral(resourceName: "bigNav")
            }
        }
                
        
        self.setTabBarItems()
        self.setStatusBarGradientColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTabBarItems() {
        
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "home")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.selectedImage = UIImage(named: "homeActive")?.withRenderingMode(.alwaysOriginal)
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        myTabBarItem1.title = "Home"
        myTabBarItem1.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4117647059, green: 0.8784313725, blue: 0.8588235294, alpha: 1)], for: .selected)
        myTabBarItem1.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)], for: .normal)
        
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "faq")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2.selectedImage = UIImage(named: "faqActive")?.withRenderingMode(.alwaysOriginal)
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        myTabBarItem2.title = "FAQ"
        myTabBarItem2.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4117647059, green: 0.8784313725, blue: 0.8588235294, alpha: 1)], for: .selected)
        myTabBarItem2.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)], for: .normal)
        
        
        let myTabBarItem3 = (self.tabBar.items?[2])!as UITabBarItem
        myTabBarItem3.image = UIImage(named: "massage")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem3.selectedImage = UIImage(named: "massageActive")?.withRenderingMode(.alwaysOriginal)
        myTabBarItem3.imageInsets = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        myTabBarItem3.title = "Messages"
        myTabBarItem3.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4117647059, green: 0.8784313725, blue: 0.8588235294, alpha: 1)], for: .selected)
        myTabBarItem3.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)], for: .normal)
        
        
        let myTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
        myTabBarItem4.image = UIImage(named: "account")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem4.selectedImage = UIImage(named: "accountActive")?.withRenderingMode(.alwaysOriginal)
        myTabBarItem4.imageInsets = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        myTabBarItem4.title = "Account"
        myTabBarItem4.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4117647059, green: 0.8784313725, blue: 0.8588235294, alpha: 1)], for: .selected)
        myTabBarItem4.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)], for: .normal)
        
        /*
        if let tabItems = tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[2]
            tabItem.badgeValue = "1"
            tabItem.badgeColor = AppThemeColor
        }
        */
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let indexOfTab = tabBar.items?.firstIndex(of: item)
        
        if let login = AppUserDefaults.value(forKey: "isLogin") as? Bool, !login {
            
            if indexOfTab == 2 {
                let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "LoginVC") as! LoginVC
                vc.isLoggedIn = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK: Custom Method
    func resize(image: UIImage, newWidth: CGFloat) -> UIImage {

        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: image.size.height))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: image.size.height))
        // image.drawInRect( CGRect(x: 0, y: 0, width: newWidth, height: image.size.height))  in swift 2
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
