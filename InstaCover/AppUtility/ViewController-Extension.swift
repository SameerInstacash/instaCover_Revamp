//
//  ViewController.swift
//  InstaCashSDK
//
//  Created by Sameer Khan on 06/07/21.
//

import UIKit

extension UIViewController {
 
    func setStatusBarGradientColor() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ AppFirstThemeColor.cgColor, AppSecondThemeColor.cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        
        if #available(iOS 13.0, *) {
            
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            gradientLayer.frame = CGRect(x:0, y:0, width:app.statusBarFrame.size.width, height:app.statusBarFrame.size.height)
            
            let statusbarView = UIView()
            //statusbarView.backgroundColor = firstColor
            statusbarView.layer.addSublayer(gradientLayer)
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            //statusBar?.backgroundColor = firstColor
            statusBar?.layer.addSublayer(gradientLayer)
        }
    }
    
    
    func hideKeyboardWhenTappedAroundView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // To Save Language JSON
    func saveLocalizationString(_ langDict : NSDictionary) {
        let doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let destinationPath = doumentDirectoryPath.appendingPathComponent("AppLanguage")
        let URL = NSURL.fileURL(withPath: destinationPath)
                
        let success = langDict.write(to: URL, atomically: true)
        print("write: ", success)
    }
    
    // To Get Language value according to key from saved JSON
    func getLocalizatioStringValue(key : String) -> String {
        let doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let destinationPath = doumentDirectoryPath.appendingPathComponent("AppLanguage")
        let dict = NSDictionary.init(contentsOfFile: destinationPath)
        return (dict?.object(forKey: key) as? String ?? key)
    }

    
    func showaAlert(message: String, title: String = "") {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: self.getLocalizatioStringValue(key: "OK"), style: .default, handler: nil)
        alertController.addAction(OKAction)
        
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = self.view.bounds
        
        alertController.view.tintColor = AppThemeColor
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlert(title: String, message: String, alertButtonTitles: [String], alertButtonStyles: [UIAlertAction.Style], vc: UIViewController, completion: @escaping (Int)->Void) -> Void
    {
        let alert = UIAlertController(title: title,message: message,preferredStyle: UIAlertController.Style.alert)
        
        for title in alertButtonTitles {
            let actionObj = UIAlertAction(title: title,
                                          style: alertButtonStyles[alertButtonTitles.firstIndex(of: title)!], handler: { action in
                                            completion(alertButtonTitles.firstIndex(of: action.title!)!)
            })
            
            alert.addAction(actionObj)
        }
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = self.view.bounds
        
        alert.view.tintColor = AppThemeColor
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        vc.present(alert, animated: true, completion: nil)
    }
    
    // MARK: UIViewController Navigation in SDK
    
    func NavigateToHomePage() {
        /*
        AppResultJSON = JSON()
        AppResultString = ""
        AppHardwareQuestionsData = nil
        hardwareQuestionsCount = 0
        AppQuestionIndex = -1
        self.resetAppUserDefaults()
        
        let StoreTokenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreTokenVC") as! StoreTokenVC
            
        let nav = UINavigationController(rootViewController: self)
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = nav
        nav.navigationBar.isHidden = true
        nav.pushViewController(StoreTokenVC, animated: true)
        */
    }
    
    func resetAppUserDefaults() {
        let defaults = AppUserDefaults
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            
            if key != "imei_number" {
                defaults.removeObject(forKey: key)
            }
            
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{0,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

struct AppOrientationUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        AppOrientationLock = orientation
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}

class CustomUserDefault: NSObject {
    
    static  func setUserId(data : Int?) {
        UserDefaults.standard.set(data, forKey: "UserId")
    }
    
    static  func getUserId()-> Int? {
        return UserDefaults.standard.object(forKey: "UserId") as? Int ?? 0
    }
    
    static func removeUserId() {
        UserDefaults.standard.removeObject(forKey: "UserId")
    }
    
    //set
    static func saveUserData(modal : UserMsg) {
        
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: modal.dictionaryRepresentation(), requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: "UserData")
            UserDefaults.standard.synchronize()
        } catch {
            print("Failed to save meals...")
        }
    
    }
    
    //get
    static func getUserData() -> UserMsg? {
        
        do {
            
            if let data = UserDefaults.standard.data(forKey: "UserData"), let myLoginData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String:Any] {
                
                let loginData = UserMsg.init(object: myLoginData)
                UserDefaults.standard.synchronize()
                return loginData
            }
            
        }catch {
            UserDefaults.standard.synchronize()
            return nil
        }
        
        return nil
        
    }
    
    //Remove Login Data
    static func removeLoginData() {
        UserDefaults.standard.removeObject(forKey: "UserData")
    }
    
    //set Token Time
    static func saveTokenTime(data : Double?) {
        UserDefaults.standard.set(data, forKey: "TokenTime")
    }
    
    //get Token Time
    static  func getTokenTime()-> Double? {
        return UserDefaults.standard.object(forKey: "TokenTime") as? Double ?? 0.0
    }
    
    //Remove Toke Time
    static func removeTokenTime() {
        UserDefaults.standard.removeObject(forKey: "TokenTime")
    }
    
    //set UserName
    static func saveUserName(name : String) {
        UserDefaults.standard.set(name, forKey: "UserName")
        UserDefaults.standard.synchronize()
    }
    
    //get UserName
    static func getUserName() -> String? {
        return UserDefaults.standard.object(forKey: "UserName") as? String ?? ""
    }
    
    //Remove UserName
    static func removeUserName() {
        UserDefaults.standard.removeObject(forKey: "UserName")
    }
    
    //set Password
    static func saveUserPassword(password : String) {
        UserDefaults.standard.set(password, forKey: "UserPassword")
        UserDefaults.standard.synchronize()
    }
    
    //get Password
    static func getUserPassword() -> String? {
        return UserDefaults.standard.object(forKey: "UserPassword") as? String ?? "0"
    }
    
    //Remove Password
    static func removeUserPassword() {
        UserDefaults.standard.removeObject(forKey: "UserPassword")
    }
    
    
}
