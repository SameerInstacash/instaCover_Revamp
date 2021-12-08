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
import FacebookCore
import FBSDKCoreKit
import WebKit

class SignUpVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldContact: UITextField!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    @IBOutlet weak var baseWebView: UIView!
    @IBOutlet weak var webviewHeightConstraint: NSLayoutConstraint!
    var webView: WKWebView!

    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    var isMalaysian = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
        
        self.LoadWebView()
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
                                                
                        
                        AppEvents.logEvent(AppEvents.Name.completedRegistration, parameters: [AppEvents.ParameterName.registrationMethod.rawValue : "email_registration"])
                        
                        
                        /*
                        let fbParameters: [AppEvents.ParameterName: Any] = [AppEvents.ParameterName.init(rawValue: AppEvents.ParameterName.registrationMethod.rawValue) : "email_registration"]
                        AppEvents.logEvent(AppEvents.Name.purchased, parameters: fbParameters)
                        */
                        
                        
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

    //MARK: Custom Methods
    func LoadWebView() {
        webView = self.addWKWebView(viewForWeb: self.baseWebView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        
                
        let html = "<html style='text-align: center;'>By clicking the 'Sign Up' button, you have agreed to the <a href='https://shop.compasia.com/pages/privacy-policy'> Privacy Policy</a> and <a href='https://cover-uat.getinstacash.in/termsAndConditions.php'> Terms & Conditions</a></html>"
        
        let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
        
        
        let htmlString = """
            <style>
            @font-face
            {
                font-family: 'OpenSans';
                font-weight: normal;
                src: url(OpenSans-Regular.ttf);
            }
            a:link
            {
                color: \(AppFirstThemeColorHexString);
            }
            </style>
                        <span style="font-family: 'OpenSans'; font-weight: normal; font-size: 14; color: gray">\(headerString + html)</span>
            """
                
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
        
    }
    
    func addWKWebView(viewForWeb:UIView) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
    
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = preferences
        
        //let webView = WKWebView(frame: viewForWeb.frame, configuration: webConfiguration)
        let webView = WKWebView(frame: CGRect.init(x: 10.0, y: 10.0, width: self.baseWebView.bounds.width - 20.0, height: self.baseWebView.bounds.height - 20.0), configuration: webConfiguration)
        
        //webView.frame.origin = CGPoint.init(x: 0, y: 0)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        ///webView.frame.size = viewForWeb.frame.size
        //webView.center = viewForWeb.center
        viewForWeb.addSubview(webView)
        return webView
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard case .linkActivated = navigationAction.navigationType,
              let url = navigationAction.request.url
        else {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
        
        if navigationAction.request.url?.lastPathComponent == "termsAndConditions.php" {
            
            DispatchQueue.main.async {
                let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "WebViewVC") as! WebViewVC
                vc.isComeFrom = "Terms & Conditions"
                vc.loadableUrlStr = url.absoluteString
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if navigationAction.request.url?.lastPathComponent == "privacy-policy" {
            
            DispatchQueue.main.async {
                let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "WebViewVC") as! WebViewVC
                vc.isComeFrom = "Privacy Policy"
                vc.loadableUrlStr = url.absoluteString
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
            self.webviewHeightConstraint?.constant = (height as! CGFloat) + 20.0
        })
    }
    
}
