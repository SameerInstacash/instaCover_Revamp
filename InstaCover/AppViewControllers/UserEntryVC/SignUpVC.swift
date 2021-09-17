//
//  SignUpVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD

class SignUpVC: UIViewController {
    
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldContact: UITextField!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!

    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    var isMalaysian = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.btnYes.isSelected = true
    }
    
    //MARK: Custom Methods
    func setUIElements() {
        self.setStatusBarGradientColor()
    }
    
    func validation() -> Bool {
        
        if self.txtFieldName.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter your name"))
            return false
            
        }else if (self.txtFieldEmail.text?.count ?? 0) < 4 {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter your email"))
            return false
            
        }else if !(self.isValidEmail(self.txtFieldEmail.text ?? "")) {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter valid email"))
            return false
            
        }else if self.txtFieldContact.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter your contact no."))
            return false
            
        }else if (self.txtFieldContact.text?.count ?? 0) < 10 || (self.txtFieldContact.text?.count ?? 0) > 11 {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter valid contact no."))
            return false
            
        }
        
        return true
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func yesBtnClicked(_ sender: UIButton) {
        self.btnYes.isSelected = true
        self.btnNo.isSelected = false
        self.isMalaysian = "1"
    }
    
    @IBAction func noBtnClicked(_ sender: UIButton) {
        self.btnYes.isSelected = false
        self.btnNo.isSelected = true
        self.isMalaysian = "0"
    }
    
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if reachability?.connection.description != "No Connection" {
            if self.validation() {
                self.customerSignUp()
            }
        }else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
        }
    }
 
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "LoginVC") as! LoginVC
        vc.isComeFromSignUp = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Web Service Methods
    func showHudLoader() {
        hud.textLabel.text = ""
        hud.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7764705882, blue: 0.7568627451, alpha: 0.5)
        hud.show(in: self.view)
    }
    
    func customerSignUp() {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "email" : self.txtFieldEmail.text ?? "",
            "name" : self.txtFieldName.text ?? "",
            "contact" : self.txtFieldContact.text ?? "",
            "isMalaysian" : self.isMalaysian
        ]
        
        //print(params)
        self.showHudLoader()
    
        let webService = AF.request(AppURL.kCustomerSignup, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        //let userLoginData = UserData.init(json: json)
                        //CustomUserDefault.saveUserData(modal: userLoginData.userMsg ?? UserMsg(object: [:]))
                        
                        let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "LoginVC") as! LoginVC
                        vc.isComeFromSignUp = true
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
