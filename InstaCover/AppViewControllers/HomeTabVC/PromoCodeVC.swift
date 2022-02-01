//
//  PromoCodeVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 31/01/22.
//

import UIKit
import JGProgressHUD
import Alamofire
import SwiftyJSON
import AlamofireImage
import FacebookCore
import FBSDKCoreKit

class PromoCodeVC: UIViewController {
    
    @IBOutlet weak var lblDeviceBrandModel: UILabel!
    @IBOutlet weak var lblCoverageAndTenure: UILabel!
    @IBOutlet weak var lblServiceRequestFee: UILabel!
    @IBOutlet weak var lblCouponAmount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var btnPromoCode: UIButton!
    
    @IBOutlet weak var btnPromoApplied: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var promoRemoveView: UIView!
    @IBOutlet weak var promoApplyView: UIView!
    
    var customerDeviceDict = [String:Any]()
    
    var paymentSDK : Ipay?
    var requeryPayment:IpayPayment?
    var paymentView : UIView?
    var viewModel : DetailViewModel = DetailViewModel()
    
    var apiTimer: Timer?
    var apiCount = 0
    var strCouponCode : String?
    
    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plan = (AppDelegate.sharedDelegate().insurance) + "-" + AppDelegate.sharedDelegate().selectedTerm
        self.lblDeviceBrandModel.text = AppDelegate.sharedDelegate().selectedProductName
        self.lblCoverageAndTenure.text = plan
        self.lblServiceRequestFee.text = AppCurrency + " " + AppDelegate.sharedDelegate().insuredAmount
        self.lblCouponAmount.text = AppCurrency + " " + "0"
        self.lblTotalAmount.text = AppCurrency + " " + AppDelegate.sharedDelegate().insuredAmount
    
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
    }
    
    func initiateIpay88SDK() {
        
        let userData = CustomUserDefault.getUserData()
        
        dump(viewModel.detail)
        requeryPayment = IpayPayment()
        requeryPayment?.paymentId = "55" // viewModel.detail.paymentID
        requeryPayment?.merchantKey = "lObOlu9PD3" //viewModel.detail.merchantKey
        requeryPayment?.merchantCode = "M28460_S0002" //viewModel.detail.merchantCode
        requeryPayment?.refNo = AppDelegate.sharedDelegate().insuredQuotationID //viewModel.detail.refNo
        requeryPayment?.amount = AppDelegate.sharedDelegate().insuredAmount //viewModel.detail.amount
        requeryPayment?.currency = "MYR" //viewModel.detail.currency
        requeryPayment?.prodDesc = AppDelegate.sharedDelegate().insurance + " with " + AppDelegate.sharedDelegate().selectedTerm //viewModel.detail.productDescription
        requeryPayment?.userName = userData?.name //viewModel.detail.customerName
        requeryPayment?.userEmail = userData?.email //viewModel.detail.email
        requeryPayment?.userContact = userData?.mobile //viewModel.detail.phoneNumber
        requeryPayment?.remark = AppUserDefaults.value(forKey: "IMEI") as? String ?? ""  //viewModel.detail.remark
        requeryPayment?.lang = "ISO-8859-1" //viewModel.detail.language
        requeryPayment?.country = "MY" //viewModel.detail.country
        //requeryPayment?.backendPostURL = "https://instacover-uat.getinstacash.in/index.php/setiPayTransaction" //viewModel.detail.backendURL
        requeryPayment?.backendPostURL = AppURL.kSetiPayTransaction
                
        /* 2. SDK inititalization */
        paymentSDK = Ipay()
        paymentSDK?.delegate = self
        
        paymentView = paymentSDK?.checkout(requeryPayment)
        /* 3. Payment Checkout Method - END */
        self.view.addSubview(paymentView!)
        
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completePaymentBtnClicked(_ sender: UIButton) {
        self.showAlert(title: "Reminder", message: "After the payment is successful. You requires to complete the device diagnosis to entitle to the service", alertButtonTitles: ["Cancel","Ok"], alertButtonStyles: [.destructive, .default], vc: self) { index in
            
            if index == 1 {
                //self.saveCustomerQuote()
                
                self.initiateIpay88SDK()
                
            }
        }
    }
    
    @IBAction func applyPromoCodeBtnClicked(_ sender: UIButton) {
        
        //if sender.titleLabel?.text == self.getLocalizatioStringValue(key: "Apply promo code") {
            
            let alert = UIAlertController(title: self.getLocalizatioStringValue(key: "Apply Promo"), message: "", preferredStyle: UIAlertController.Style.alert)
            
            let doneAction = UIAlertAction(title: self.getLocalizatioStringValue(key: "Apply"), style: .default) { (alertAction) in
                let textField = alert.textFields![0] as UITextField
                
                guard !(textField.text?.isEmpty ?? false) else {
                    
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Enter Valid Promo Code"))
                    return
                }
                
                print(textField.text ?? "nothing")
                print("Promo code applied!")
                
                self.strCouponCode = textField.text ?? ""
                self.applyPromoCodeApiCall()
                
            }
            
            let cancelAction = UIAlertAction(title: self.getLocalizatioStringValue(key: "Cancel"), style: .destructive) { (alertAction) in
                
            }
            
            alert.addTextField { (textField) in
                textField.placeholder = self.getLocalizatioStringValue(key: "Enter Promo code")
            }
            
            alert.addAction(doneAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true) {
                
            }
            
        /*
        }else {
            
            self.removePromoCodeApiCall()
        }
        */
    
    }
    
    @IBAction func removePromoCodeBtnClicked(_ sender: UIButton) {
        self.removePromoCodeApiCall()
    }
    
    //MARK:- Web Service Methods
    func showHudLoader(_ text :  String) {
        hud.textLabel.text = text
        hud.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7764705882, blue: 0.7568627451, alpha: 0.5)
        hud.show(in: self.view)
    }
    
    func saveCustomerQuote() {
        
        let userData = CustomUserDefault.getUserData()
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "customerId" : userData?.internalIdentifier ?? "",
            "productId" : AppDelegate.sharedDelegate().selectedProductID,
            "policyId" : AppDelegate.sharedDelegate().selectedPolicyID,
            "name" : self.customerDeviceDict["name"] ?? "",
            "contact" : self.customerDeviceDict["contact"] ?? "",
            "nricNo" : self.customerDeviceDict["nricNo"] ?? "",
            "email" : self.customerDeviceDict["email"] ?? "",
            "uniqueId" : UIDevice.current.identifierForVendor!.uuidString,
            "uniqueType" : "ios",
            "imeiNumber" : AppUserDefaults.value(forKey: "IMEI") ?? "",
        ]
        
        print(params)
        self.showHudLoader("")
        
        let webService = AF.request(AppURL.kSaveCustomerQuote, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        AppDelegate.sharedDelegate().insuredQuotationID = json["quotationId"].stringValue
                        
                        if AppDelegate.sharedDelegate().isCurrentDevice {
                                                        
                            /*
                            let fbParameters: [String: Any] = ["CONTENT" : AppDelegate.sharedDelegate().insurance + " " + AppDelegate.sharedDelegate().selectedTerm,
                                                             "CONTENT_ID" : AppDelegate.sharedDelegate().selectedPolicyID,
                                                             "CONTENT_TYPE" : UIDevice.current.currentModelName,
                                                             "NUM_ITEMS" : "1",
                                                             "INFO_AVAILABLE" : "0",
                                                             "CURRENCY" : "MYR"]

                          
                            AppEvents.logEvent(AppEvents.Name.initiatedCheckout, parameters: fbParameters)
                            */
                            
                            
                            let fbParameters: [AppEvents.ParameterName: Any] = [AppEvents.ParameterName.init(rawValue: "CONTENT") : AppDelegate.sharedDelegate().insurance + " " + AppDelegate.sharedDelegate().selectedTerm,
                                             AppEvents.ParameterName.init(rawValue: "CONTENT_ID") : AppDelegate.sharedDelegate().selectedPolicyID,
                                             AppEvents.ParameterName.init(rawValue: "CONTENT_TYPE") : UIDevice.current.currentModelName,
                                             AppEvents.ParameterName.init(rawValue: "NUM_ITEMS") : "1",
                                             AppEvents.ParameterName.init(rawValue: "INFO_AVAILABLE") : "0",
                                             AppEvents.ParameterName.init(rawValue: "CURRENCY") : "MYR"]
                            
                            AppEvents.logEvent(AppEvents.Name.initiatedCheckout, parameters: fbParameters)
                            
                            
                            //let vc = DesignManager.loadViewControllerFromHomeStoryBoard(identifier: "PaymentSuccessVC") as! PaymentSuccessVC
                            //self.navigationController?.pushViewController(vc, animated: true)
                            
                            self.initiateIpay88SDK()
                            
                        }else {
                            
                            //let vc = DesignManager.loadViewControllerFromHomeStoryBoard(identifier: "PaymentSuccessVC") as! PaymentSuccessVC
                            //self.navigationController?.pushViewController(vc, animated: true)
                            
                            self.initiateIpay88SDK()
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
    
    func getIpayTransactionStatus() {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "referenceNumber" : AppDelegate.sharedDelegate().insuredQuotationID,
        ]
        
        //print(params)
        self.showHudLoader("")
        
        let webService = AF.request(AppURL.kgetiPayTransaction, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    //print(json)
                    
                    if json["status"] == "Success" {
                        self.hud.dismiss()
                        
                        self.apiTimer?.invalidate()
                        self.apiTimer = nil
                        self.apiCount = 0
                        
                        AppDelegate.sharedDelegate().referenceNumber = json["msg"]["referenceNumber"].stringValue
                        
                        
                        /*
                        let fbParameters: [String: Any] = ["amount" : AppDelegate.sharedDelegate().insuredAmount]
                        AppEvents.logEvent(AppEvents.Name.purchased, parameters: fbParameters)
                        */
                        
                        
                        //*
                        let fbParameters: [AppEvents.ParameterName: Any] = [AppEvents.ParameterName.init(rawValue: "amount") : AppDelegate.sharedDelegate().insuredAmount]
                        AppEvents.logEvent(AppEvents.Name.purchased, parameters: fbParameters)
                        //*/
                        
                        
                        
                        let vc = DesignManager.loadViewControllerFromHomeStoryBoard(identifier: "PaymentSuccessVC") as! PaymentSuccessVC
                        self.navigationController?.pushViewController(vc, animated: true)
                     
                    }else {
                        //self.showaAlert(message: json["msg"].stringValue)
                
                        if self.apiCount >= 20 {
                            
                            self.hud.dismiss()
                            
                            self.apiTimer?.invalidate()
                            self.apiTimer = nil
                            self.apiCount = 0
                            
                            self.showaAlert(message: "Please contact customer support")
                        }else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.getIpayTransactionStatus()
                            }
                        }
                        
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
    
    func applyPromoCodeApiCall() {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "quoteId" : AppDelegate.sharedDelegate().insuredQuotationID,
            "code" : self.strCouponCode ?? ""
        ]
        
        print(params)
        self.showHudLoader("")
        
        let webService = AF.request(AppURL.kApplyPromo, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    //print(json)
                    
                    if json["status"] == "Success" {
                        
                        DispatchQueue.main.async {
                            
                            self.btnPromoApplied.setTitle("Promo applied " + (self.strCouponCode ?? ""), for: .normal)
                            
                            self.promoRemoveView.isHidden = !self.promoRemoveView.isHidden
                            self.promoApplyView.isHidden = !self.promoApplyView.isHidden
                            
                                                        
                            AppDelegate.sharedDelegate().insuredAmount = json["newAmount"].stringValue
                            
                            self.lblServiceRequestFee.text = AppCurrency + " " + json["newAmount"].stringValue
                            self.lblCouponAmount.text = AppCurrency + " " + json["promoAmount"].stringValue
                            self.lblTotalAmount.text =  json["newAmount"].stringValue
                        
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
    
    func removePromoCodeApiCall() {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "quoteId" : AppDelegate.sharedDelegate().insuredQuotationID,
            "code" : self.strCouponCode ?? ""
        ]
        
        print(params)
        self.showHudLoader("")
        
        let webService = AF.request(AppURL.kRemovePromo, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    //print(json)
                    
                    if json["status"] == "Success" {
                    
                        DispatchQueue.main.async {
                            
                            self.btnPromoApplied.setTitle(" ", for: .normal)
                        
                            self.promoRemoveView.isHidden = !self.promoRemoveView.isHidden
                            self.promoApplyView.isHidden = !self.promoApplyView.isHidden
                            
                            AppDelegate.sharedDelegate().insuredAmount = json["newAmount"].stringValue
                            
                            self.lblServiceRequestFee.text = AppCurrency + " " + json["newAmount"].stringValue
                            self.lblCouponAmount.text = AppCurrency + " " + json["promoAmount"].stringValue
                            self.lblTotalAmount.text =  json["newAmount"].stringValue
                            
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

extension PromoCodeVC : PaymentResultDelegate {
    
    @objc func update() {
        //ServiceManager.showHUD = false
        
        self.apiCount += 1
        //self.getIpayTransactionStatus()
    }
    
    func paymentSuccess(_ refNo: String!, withTransId transId: String!, withAmount amount: String!, withRemark remark: String!, withAuthCode authCode: String!) {
        
        //ServiceManager.showHUD = true
        apiTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(PaymentDetailVC.update), userInfo: nil, repeats: true)
        
        //let message = "refNo=\(String(describing: refNo!))\n transId=\(String(describing: transId!))\n amount=\(String(describing: amount!))\n remark=\(String(describing: remark!)) \nauthCode:\(String(describing: authCode!))"
        //showMessage(title: "Payment Success", message: message)
    }
    
    func paymentFailed(_ refNo: String!, withTransId transId: String!, withAmount amount: String!, withRemark remark: String!, withErrDesc errDesc: String!) {
        
        print("Failed")
        
        let message = "refNo=\(String(describing: refNo!)) \n transId=\(String(describing: transId!)) \n amount=\(String(describing: amount!)) \n remark=\(String(describing: remark!)) \n errDesc:\(String(describing: errDesc!))"
        
        showMessage(title: "Payment Failed", message: message)
    }
    
    func paymentCancelled(_ refNo: String!, withTransId transId: String!, withAmount amount: String!, withRemark remark: String!, withErrDesc errDesc: String!) {
        
        print("Cancel")
        
        let message = "refNo=\(String(describing: refNo!)) \n transId=\(String(describing: transId!)) \n amount=\(String(describing: amount!)) \n remark=\(String(describing: remark!)) \n errDesc:\(String(describing: errDesc!))"
        
        showMessage(title: "Payment Cancelled", message: message)
    }
    
    func requerySuccess(_ refNo: String!, withMerchantCode merchantCode: String!, withAmount amount: String!, withResult result: String!) {
        print("something")
    }
    
    func requeryFailed(_ refNo: String!, withMerchantCode merchantCode: String!, withAmount amount: String!, withErrDesc errDesc: String!) {
        print("something")
    }
    
    func showMessage(title : String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            self.paymentView?.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
