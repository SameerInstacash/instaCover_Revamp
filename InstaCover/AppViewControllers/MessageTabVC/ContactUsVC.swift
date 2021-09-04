//
//  ContactUsVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 06/08/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD

class ContactUsVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtViewMessage: UITextView!

    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
    }
    
    //MARK: Custom Method
    func setUIElements() {
        //self.setStatusBarGradientColor()
        
        self.txtViewMessage.delegate = self
    }
    
    func validation() -> Bool {
        
        if self.txtFieldName.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter your name"))
            return false
            
        }else if self.txtFieldEmail.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter your email"))
            return false
            
        }else if !(self.isValidEmail(self.txtFieldEmail.text ?? "")) {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter valid email"))
            return false
            
        }else if self.txtViewMessage.text.isEmpty || self.txtViewMessage.text == "Message" {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter your message"))
            return false
            
        }
        
        return true
    }
    
    //MARK: - TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Message" {
            self.txtViewMessage.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Message"
        }
    }
    
    //MARK: IBAction
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if reachability?.connection.description != "No Connection" {
            if self.validation() {
                self.contactUs()
            }
        }else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
        }
    }
    
    //MARK:- Web Service Methods
    func showHudLoader() {
        hud.textLabel.text = ""
        hud.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7764705882, blue: 0.7568627451, alpha: 0.5)
        hud.show(in: self.view)
    }
    
    func contactUs() {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "email" : self.txtFieldEmail.text ?? "",
            "name" : self.txtFieldName.text ?? "",
            "message" : self.txtViewMessage.text ?? ""
        ]
        
        //print(params)
        self.showHudLoader()
        
        let webService = AF.request(AppURL.kEnquiryContactUs, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        self.showAlert(title: "", message: json["msg"].stringValue, alertButtonTitles: ["OK"], alertButtonStyles: [.default], vc: self) { index in
                            
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
