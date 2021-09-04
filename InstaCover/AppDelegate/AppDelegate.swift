//
//  AppDelegate.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit
import SwiftyJSON
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    var nav : UINavigationController?
    
    var currentProductID : String = ""
    var isCurrentDevice : Bool = true
    var selectedProductName : String = ""
    var selectedProductBrand : String = ""
    var selectedProductID : String = ""
    var selectedTerm : String = ""
    var selectedPolicyID : String = ""
    var insuredQuotationID : String = ""
    var insuredAmount : String = ""
    var insuredServiceFee : String = ""
    
    var isVideoRequired : String = ""
    var referenceNumber:String = ""
    var insurance : String = ""
    var faqHtml : String = ""
    var tncHtml : String = ""
    var descriptionHtml : String = ""       

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
    
    //MARK: Custom Methods
    
    func navigateToLoginScreen() {
        DispatchQueue.main.async { [self] in
            let  story = UIStoryboard.init(name: "Main", bundle: nil)
            self.window?.rootViewController = story.instantiateViewController(withIdentifier: "Login_Nav")
        }
    }
    
    func navigateToDashboardScreen() {
        DispatchQueue.main.async {
            let  story = UIStoryboard.init(name: "Dashboard", bundle: nil)
            self.window?.rootViewController = story.instantiateViewController(withIdentifier: "Dashboard_Nav")
        }
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    class func sharedDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    internal var shouldRotate = false
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if shouldRotate {
            return .allButUpsideDown
        } else {
            return .portrait
        }
    }
    
}

