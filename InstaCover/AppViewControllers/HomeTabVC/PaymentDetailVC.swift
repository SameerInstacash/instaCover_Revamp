//
//  PaymentDetailVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 12/08/21.
//

import UIKit
import JGProgressHUD
import Alamofire
import SwiftyJSON
import AlamofireImage

class PaymentDetailVC: UIViewController {

    @IBOutlet weak var txtFieldFullName: UITextField!
    @IBOutlet weak var txtFieldIcPassport: UITextField!
    @IBOutlet weak var txtFieldContactNumber: UITextField!
    @IBOutlet weak var txtFieldEmailAddress: UITextField!
    @IBOutlet weak var txtFieldDeviceIMEI: UITextField!
    @IBOutlet weak var txtFieldCoverageTenureType: UITextField!
    @IBOutlet weak var txtFieldServiceFee: UITextField!
    @IBOutlet weak var txtFieldBrandAndModel: UITextField!
    @IBOutlet weak var btnCoverageTenureType: UIButton!

    var arrDropCoverageTenure = [String]()
    
    var paymentSDK : Ipay?
    var requeryPayment:IpayPayment?
    var paymentView : UIView?
    var viewModel : DetailViewModel = DetailViewModel()
    
    var apiTimer: Timer?
    
    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plan = (AppDelegate.sharedDelegate().insurance) + "-" + AppDelegate.sharedDelegate().selectedTerm
        
        if let userData = CustomUserDefault.getUserData() {
            self.txtFieldFullName.text = userData.name
            self.txtFieldIcPassport.text = ""
            self.txtFieldContactNumber.text = userData.mobile
            self.txtFieldEmailAddress.text = userData.email
            //self.txtFieldDeviceIMEI.text = AppUserDefaults.value(forKey: "IMEI") as? String ?? ""
            self.txtFieldCoverageTenureType.text = plan
            self.txtFieldServiceFee.text = AppCurrency + " " + AppDelegate.sharedDelegate().insuredAmount
            self.txtFieldBrandAndModel.text = AppDelegate.sharedDelegate().selectedProductName
        }
        
        if AppDelegate.sharedDelegate().isCurrentDevice {
            self.txtFieldDeviceIMEI.isUserInteractionEnabled = false
            self.txtFieldDeviceIMEI.text = AppUserDefaults.value(forKey: "IMEI") as? String ?? ""
        }else {
            self.txtFieldDeviceIMEI.isUserInteractionEnabled = true
            self.txtFieldDeviceIMEI.placeholder = "Enter IMEI"
        }
        
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
    
    func validation() -> Bool {
        
        if self.txtFieldFullName.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter your full name"))
            return false
            
        }else if self.txtFieldIcPassport.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter your IC/Passport number"))
            return false
            
        }else if self.txtFieldContactNumber.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter your contact no."))
            return false
            
        }else if self.txtFieldEmailAddress.text?.isEmpty ?? false {
        
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter your email"))
            return false
            
        }
        else if !(self.isValidEmail(self.txtFieldEmailAddress.text ?? "")) {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter valid email"))
            return false
            
        }else if self.txtFieldDeviceIMEI.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter IMEI of device"))
            return false
            
        }else if self.txtFieldDeviceIMEI.text?.count != 15  {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please enter vaild IMEI number."))
            return false
            
        }
        
        return true
    }
    
    func initiateIpay88SDK() {
        
        let userData = CustomUserDefault.getUserData()
        
        dump(viewModel.detail)
        requeryPayment = IpayPayment()
        requeryPayment?.paymentId = "" // viewModel.detail.paymentID
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
        requeryPayment?.backendPostURL = "https://instacover-uat.getinstacash.in/index.php/setiPayTransaction" //viewModel.detail.backendURL
        
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
    
    @IBAction func coverageTenureBtnClicked(_ sender: UIButton) {
        
        /*
        let existingFileDropDown = DropDown()
        existingFileDropDown.anchorView = sender
        existingFileDropDown.cellHeight = 40
        existingFileDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        let typeOfFileArray = self.arrDropCoverageTenure
        existingFileDropDown.dataSource = typeOfFileArray
        
        // Action triggered on selection
     
        existingFileDropDown.selectionAction = { [unowned self] (index, item) in
            //sender.setTitle(item, for: .normal)
            self.txtFieldCoverageTenureType.text = item
        }
        existingFileDropDown.show()
        */
        
    }
    
    @IBAction func continueBtnClicked(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if reachability?.connection.description != "No Connection" {
            if self.validation() {
                self.saveCustomerQuote()
            }
        }else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
        }
                
        //self.initiateIpay88SDK()
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
            "name" : self.txtFieldFullName.text ?? "",
            "contact" : self.txtFieldContactNumber.text ?? "",
            "nricNo" : self.txtFieldIcPassport.text ?? "",
            "email" : self.txtFieldEmailAddress.text ?? "",
            "uniqueId" : UIDevice.current.identifierForVendor!.uuidString,
            "uniqueType" : "ios",
            "imeiNumber" : AppUserDefaults.value(forKey: "IMEI") ?? "",
        ]
        
        //print(params)
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
                            
                            let vc = DesignManager.loadViewControllerFromHomeStoryBoard(identifier: "PaymentSuccessVC") as! PaymentSuccessVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            //self.initiateIpay88SDK()
                        }else {
                            let vc = DesignManager.loadViewControllerFromHomeStoryBoard(identifier: "PaymentSuccessVC") as! PaymentSuccessVC
                            self.navigationController?.pushViewController(vc, animated: true)
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
        
        print(params)
        self.showHudLoader("")
        
        let webService = AF.request(AppURL.kgetiPayTransaction, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        self.apiTimer?.invalidate()
                        self.apiTimer = nil
                        
                        AppDelegate.sharedDelegate().referenceNumber = json["msg"]["referenceNumber"].stringValue
                        
                        let vc = DesignManager.loadViewControllerFromHomeStoryBoard(identifier: "PaymentSuccessVC") as! PaymentSuccessVC
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

extension PaymentDetailVC : PaymentResultDelegate {
    
    @objc func update() {
        //ServiceManager.showHUD = false
        
        self.getIpayTransactionStatus()
    }
    
    func paymentSuccess(_ refNo: String!, withTransId transId: String!, withAmount amount: String!, withRemark remark: String!, withAuthCode authCode: String!) {
        
        //ServiceManager.showHUD = true
        apiTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(PaymentDetailVC.update), userInfo: nil, repeats: false)
        
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
