//
//  LoginVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD

class LoginVC: UIViewController {
    
    @IBOutlet weak var lblLoginMsg: UILabel!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnSkipHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSkipBottom: NSLayoutConstraint!
    
    
    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    
    var isLoggedIn : Bool = true
    var isComeFromSignUp : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUIElements()
        
        if CustomUserDefault.getUserData() != nil {
            let vc = DesignManager.loadViewControllerFromDashboardStoryBoard(identifier: "TabBarViewController") as! TabBarViewController
            AppUserDefaults.setValue(true, forKey: "isLogin")
            self.navigationController?.pushViewController(vc, animated: true)
        }
     
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            
            if self.isComeFromSignUp {
                self.lblLoginMsg.text = "You need to confirm your account.\nPlease check your email to activate your account."
                self.btnSkipHeight.constant = 0
                self.btnSkipBottom.constant = 0
                self.btnSkip.isHidden = true
            }else {
                
                if self.isLoggedIn {
                    self.lblLoginMsg.text = ""
                }else {
                    self.lblLoginMsg.text = "Register or login your details to proceed"
                    self.btnSkipHeight.constant = 0
                    self.btnSkipBottom.constant = 0
                    self.btnSkip.isHidden = true
                }
            }
            
        }
             
    }
    
    //MARK: Custom Methods
    func setUIElements() {
        self.setStatusBarGradientColor()
        
        UIView.addShadowOnViewThemeColor(baseView: self.btnSkip)
    }
    
    func validation() -> Bool {
        
        if self.txtFieldEmail.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter email"))
            return false
            
        }else if !self.isValidEmail(self.txtFieldEmail.text ?? "") {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter valid email"))
            return false
            
        }else if self.txtFieldPassword.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter password"))
            return false
            
        }else if (self.txtFieldPassword.text?.count ?? 0) < 3 {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "password should be more then 3 digits"))
            return false
            
        }
        
        return true
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func passwordEyeBtnClicked(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            
            self.txtFieldPassword.isSecureTextEntry = false
        }else {
            sender.isSelected = !sender.isSelected
            
            self.txtFieldPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func forgotPasswordBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if reachability?.connection.description != "No Connection" {
            if self.validation() {
                self.customerLogin()
            }
        }else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
        }
        
    }
    
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func skipBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromDashboardStoryBoard(identifier: "TabBarViewController") as! TabBarViewController
        AppUserDefaults.setValue(false, forKey: "isLogin")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Web Service Methods
    func showHudLoader() {
        hud.textLabel.text = ""
        hud.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7764705882, blue: 0.7568627451, alpha: 0.5)
        hud.show(in: self.view)
    }
    
    func customerLogin() {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "email" : self.txtFieldEmail.text ?? "",
            "password" : self.txtFieldPassword.text ?? ""
        ]
        
        //print(params)
        self.showHudLoader()
        
        let webService = AF.request(AppURL.kCustomerLogin, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        let userLoginData = UserData.init(json: json)
                        CustomUserDefault.saveUserData(modal: userLoginData.userMsg ?? UserMsg(object: [:]))
                        
                        let vc = DesignManager.loadViewControllerFromDashboardStoryBoard(identifier: "TabBarViewController") as! TabBarViewController
                        AppUserDefaults.setValue(true, forKey: "isLogin")
                        self.navigationController?.pushViewController(vc, animated: true)
                     
                    }else {
                        self.showaAlert(message: json["msg"].stringValue)
                    }
                    
                }catch {
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "JSON Exception"))
                }
                
                break
            case .failure(_):
                print(responseData.error ?? NSError())
                self.showaAlert(message: self.getLocalizatioStringValue(key: "Something went wrong!!"))
                break
            }
      
        }
    }
    
}

