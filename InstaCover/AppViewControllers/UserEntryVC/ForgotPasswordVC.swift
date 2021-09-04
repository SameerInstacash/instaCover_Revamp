//
//  ForgotPasswordVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
    }
    
    //MARK: Custom Methods
    func setUIElements() {
        self.setStatusBarGradientColor()
    }
    
    func validation() -> Bool {
        
        if self.txtFieldEmail.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter your email"))
            return false
            
        }else if !(self.isValidEmail(self.txtFieldEmail.text ?? "")) {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter valid email"))
            return false
            
        }
        
        return true
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgotPasswordBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if reachability?.connection.description != "No Connection" {
            if self.validation() {
                self.customerForgotPassword()
            }
        }else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
        }
        
    }
 
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Web Service Methods
    func showHudLoader() {
        hud.textLabel.text = ""
        hud.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7764705882, blue: 0.7568627451, alpha: 0.5)
        hud.show(in: self.view)
    }
    
    func customerForgotPassword() {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "email" : self.txtFieldEmail.text ?? ""
        ]
        
        //print(params)
        self.showHudLoader()
        
        let webService = AF.request(AppURL.kForgotPassword, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        self.showAlert(title: "", message: json["msg"].stringValue, alertButtonTitles: ["OK"], alertButtonStyles: [.default], vc: self) { index in
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
