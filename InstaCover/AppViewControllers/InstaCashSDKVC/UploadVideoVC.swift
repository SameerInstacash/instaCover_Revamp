//
//  UploadVideoVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 06/09/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD

class UploadVideoVC: UIViewController {

    @IBOutlet weak var imgVWLogo: UIImageView!
    @IBOutlet weak var lblIMEI: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblLinkSent: UILabel!
    
    var isDismiss : (()->(Void))?
    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    
    var userEmail : String?
    var LinkTimer = Timer()
    var bgColor : Bool = true
    var count:Int = 0
    
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
        
        self.lblMessage.text = "You will receive an e-mail from us shortly Please wait for a few seconds.\n\nIf you do not receive the email, please check your spam folder just in case the email got delivered there instead of your inbox. If so, select the email and click Not spam.\n\nPlease do not close this application.\n\nDial *#06# to view your IMEI number.\n\nTake a video of the device IMEI screen using an alternative phone or laptop.\n\nKindly wait for a confirmation email after shooting video."
        
        if let imei = AppUserDefaults.value(forKey: "IMEI") as? String {
            self.lblIMEI.text = "IMEI : \(imei)"
        }
        
        if reachability?.connection.description != "No Connection" {
            self.sendVideoLinkOnEmail()
        }else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
        }
        
    }
    
    @objc func scheduledTimerWithTimeInterval() {
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        self.LinkTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting() {
        NSLog("counting..")
        self.count += 1
        
        if (self.count >= 3)
        {
            count = 0
            self.uploadVideoCheck()
        }
        
        if (self.bgColor)
        {
            self.bgColor = false
            self.view.backgroundColor = .black
            self.lblIMEI.textColor = .white
            self.lblLinkSent.textColor = .white
            self.lblMessage.textColor = .white
            self.imgVWLogo.image = #imageLiteral(resourceName: "logo_black.png")
        }
        else
        {
            self.bgColor = true
            self.view.backgroundColor = .white
            self.lblIMEI.textColor = .black
            self.lblLinkSent.textColor = .black
            self.lblMessage.textColor = .black
            self.imgVWLogo.image = #imageLiteral(resourceName: "icon")

        }
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Web Service Methods
    func showHudLoader() {
        hud.textLabel.text = ""
        hud.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7764705882, blue: 0.7568627451, alpha: 0.5)
        hud.show(in: self.view)
    }
    
    func sendVideoLinkOnEmail() {
     
        let userData = CustomUserDefault.getUserData()
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "quotationId" : AppDelegate.sharedDelegate().insuredQuotationID,
            "email" : self.userEmail ?? "",
            "customerId" : userData?.internalIdentifier ?? AppDelegate.sharedDelegate().currentCustomerID
        ]
        
        //print(params)
        self.showHudLoader()
        
        let webService = AF.request(AppURL.kSendVideoLink, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                                                
                        self.scheduledTimerWithTimeInterval()
                        
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

    func uploadVideoCheck() {
             
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "quotationId" : AppDelegate.sharedDelegate().insuredQuotationID,
        ]
        
        print(params)
        //self.showHudLoader()
        
        let webService = AF.request(AppURL.kUploadVideoCheck, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            //self.hud.dismiss()
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        if (json["msg"].stringValue == "1")
                        {
                            self.LinkTimer.invalidate()
                            
                            
                            self.dismiss(animated: true) { }
                            if let dismiss = self.isDismiss {
                                dismiss()
                            }
                                                        
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
