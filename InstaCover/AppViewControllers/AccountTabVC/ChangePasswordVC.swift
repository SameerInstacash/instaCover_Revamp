//
//  ChangePasswordVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 06/08/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var txtFieldOldPW: UITextField!
    @IBOutlet weak var txtFieldNewPW: UITextField!
    @IBOutlet weak var txtFieldConfirmPW: UITextField!
    @IBOutlet weak var passwordStrenghtProgressView: UIProgressView!
    
    //Mark: inserted paswword is valid or not as per rules
    var isPasswordValid: Bool = false
    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: Custom Methods
    func setUIElements() {
        self.setStatusBarGradientColor()
        
        self.passwordStrenghtProgressView.setProgress(0, animated: true)
    }
    
    func validation() -> Bool {
        
        if self.txtFieldOldPW.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter your current password"))
            return false
            
        }else if (self.txtFieldOldPW.text?.count ?? 0) < 4 {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "password should be more then 4 digits"))
            return false
            
        }else if self.txtFieldNewPW.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter new password"))
            return false
            
        }else if (self.txtFieldNewPW.text?.count ?? 0) < 4 {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "new password should be more then 4 digits"))
            return false
            
        }else if self.txtFieldConfirmPW.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter confirm password"))
            return false
            
        }else if (self.txtFieldConfirmPW.text?.count ?? 0) < 4 {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "confirm password should be more then 4 digits"))
            return false
            
        }else if self.txtFieldNewPW.text != self.txtFieldConfirmPW.text {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "new password doesn't match with confirm password"))
            return false
            
        }
        
        return true
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func oldPasswordEyeBtnClicked(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            
            self.txtFieldOldPW.isSecureTextEntry = false
        }else {
            sender.isSelected = !sender.isSelected
            
            self.txtFieldOldPW.isSecureTextEntry = true
        }
    }

    @IBAction func newPasswordEyeBtnClicked(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            
            self.txtFieldNewPW.isSecureTextEntry = false
        }else {
            sender.isSelected = !sender.isSelected
            
            self.txtFieldNewPW.isSecureTextEntry = true
        }
    }

    @IBAction func confirmPasswordEyeBtnClicked(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            
            self.txtFieldConfirmPW.isSecureTextEntry = false
        }else {
            sender.isSelected = !sender.isSelected
            
            self.txtFieldConfirmPW.isSecureTextEntry = true
        }
    }

    @IBAction func saveBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if reachability?.connection.description != "No Connection" {
            if self.validation() {
                self.customerChangePassword()
            }
        }else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
        }
        
    }
    
    // MARK: - UITextField Delegate
    // Mark: Password Textfield editing Changed
    @IBAction func passwordEditingChanged(_ sender: UITextField) {
        
        if let password = self.txtFieldNewPW.text, password.isNotEmpty {
            
            //self.instructionLabel.isHidden = false
            //self.instructionLabel.alpha = 0
            
            let validationId = PasswordStrengthManager.checkValidationWithUniqueCharacter(pass: password, rules: PasswordRules.passwordRule, minLength: PasswordRules.minPasswordLength, maxLength: PasswordRules.maxPasswordLength)
            
            /*
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                self?.instructionLabel.alpha = CGFloat(validationId.alpha)
                self?.instructionHeightConstrain.constant = CGFloat(validationId.constant)
                self?.instructionLabel.text  = validationId.text
            })
            */
            
            let progressInfo = PasswordStrengthManager.setProgressView(strength: validationId.strength)
            self.isPasswordValid = progressInfo.shouldValid
            self.passwordStrenghtProgressView.setProgress(progressInfo.percentage, animated: true)
            self.passwordStrenghtProgressView.progressTintColor = UIColor.colorFrom(hexString: progressInfo.color)
            
        } else {
            
            //self.instructionLabel.isHidden = false
            //self.instructionLabel.alpha = 0
            self.passwordStrenghtProgressView.setProgress(0, animated: true)
            
            /*
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                self?.instructionLabel.alpha = 1
                self?.instructionHeightConstrain.constant = 25
                self?.instructionLabel.text = "Password cannot be empty."
            }) { (_) in
                UIView.animate(withDuration: 0.8, delay: 0, options: [], animations: { [weak self] in
                    self?.instructionLabel.alpha = 1
                    self?.instructionHeightConstrain.constant = 25
                    self?.instructionLabel.isHidden = true
                })
            }
            */
        }
        
    }
    
    
    //MARK:- Web Service Methods
    func showHudLoader() {
        hud.textLabel.text = ""
        hud.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7764705882, blue: 0.7568627451, alpha: 0.5)
        hud.show(in: self.view)
    }
    
    func customerChangePassword() {
     
        let userData = CustomUserDefault.getUserData()
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "customerId" : userData?.internalIdentifier ?? "",
            "oldPassword" : self.txtFieldOldPW.text ?? "",
            "newPassword" : self.txtFieldConfirmPW.text ?? ""
        ]
        
        //print(params)
        self.showHudLoader()
        
        let webService = AF.request(AppURL.kChangePassword, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                                                
                        self.showAlert(title: "", message: "Password Successfully Update", alertButtonTitles: ["OK"], alertButtonStyles: [.default], vc: self) { index in
                            self.navigationController?.popViewController(animated: true)
                        }
                        
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
