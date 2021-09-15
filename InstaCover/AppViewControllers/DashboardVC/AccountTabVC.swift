//
//  AccountTabVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit
//import QRCodeReader
import SwiftQRScanner
import JGProgressHUD
import Alamofire
import SwiftyJSON
import AlamofireImage

class AccountTabVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var accountTableView: UITableView!
    
    var arrItemLogin = ["Create customer request","Change password","Scan QR","Diagnosis Mode","Help","Sign out"]
    var arrItemNotLogin = ["Scan QR","Diagnosis Mode","Help"]
    var isLogin = false
    
    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    
    
    
    /*
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = true
            $0.showSwitchCameraButton = true
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.2)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: Custom Method
    func setUIElements() {
        self.setStatusBarGradientColor()
        self.registerTableViewCells()
        
        if let login = AppUserDefaults.value(forKey: "isLogin") as? Bool {
            self.isLogin = login
        }
    }
    
    //MARK: IBAction
    @IBAction func ViewUserProfileBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "ViewProfileDetailsVC") as! ViewProfileDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Custom Method
    func registerTableViewCells() {
        self.accountTableView.register(UINib.init(nibName: "AccountUserTblCell", bundle: nil), forCellReuseIdentifier: "AccountUserTblCell")
        self.accountTableView.register(UINib.init(nibName: "AccountItemTblCell", bundle: nil), forCellReuseIdentifier: "AccountItemTblCell")
    }
    
    //MARK: UITableView DataSource & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isLogin {
            return self.arrItemLogin.count + 1
        }else {
            return self.arrItemNotLogin.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            if let userData = CustomUserDefault.getUserData() {
                let AccountUserTblCell = tableView.dequeueReusableCell(withIdentifier: "AccountUserTblCell", for: indexPath) as! AccountUserTblCell
                
                AccountUserTblCell.lblUserName.text = userData.name
                
                return AccountUserTblCell
            }else {
                let AccountItemTblCell = tableView.dequeueReusableCell(withIdentifier: "AccountItemTblCell", for: indexPath) as! AccountItemTblCell
                
                if self.isLogin {
                    AccountItemTblCell.lblItemName.text = self.arrItemLogin[indexPath.row]
                }else {
                    AccountItemTblCell.lblItemName.text = self.arrItemNotLogin[indexPath.row]
                }
                
                return AccountItemTblCell
            }
            
        }else {
            let AccountItemTblCell = tableView.dequeueReusableCell(withIdentifier: "AccountItemTblCell", for: indexPath) as! AccountItemTblCell
            
            if self.isLogin {
                AccountItemTblCell.lblItemName.text = self.arrItemLogin[indexPath.row - 1]
            }else {
                AccountItemTblCell.lblItemName.text = self.arrItemNotLogin[indexPath.row]
            }
            
            return AccountItemTblCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isLogin {
            
            switch indexPath.row {
            case 1:
                let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "CreateCustomerRequestVC") as! CreateCustomerRequestVC
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "ChangePasswordVC") as! ChangePasswordVC
                self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                //self.scanQRBtnPressed(UIButton())
                                
                let scanner = QRCodeScannerController()
                scanner.delegate = self
                scanner.modalPresentationStyle = .overFullScreen
                self.present(scanner, animated: true, completion: nil)
            
            case 4:
                
                self.tabBarController?.tabBar.isHidden = true
                
                let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "DiagnosisModePopUpVC") as! DiagnosisModePopUpVC
                vc.isQuote = { quoteId in
                    
                    self.tabBarController?.tabBar.isHidden = false
                    
                    if quoteId != "" {
                        self.getQuoteData(quotationID: quoteId)
                    }else {
                        
                    }
                }
                self.present(vc, animated: true) { }
                
            case 5:
                let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "HelpVC") as! HelpVC
                self.navigationController?.pushViewController(vc, animated: true)
            case 6:
                
                self.tabBarController?.tabBar.isHidden = true
                
                let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "SignOutVC") as! SignOutVC
                vc.isTabShow = { isGo in
                    
                    if isGo {
                        CustomUserDefault.removeLoginData()
                        
                        let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "LoginVC") as! LoginVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        self.tabBarController?.tabBar.isHidden = false
                    }
                }
                self.present(vc, animated: true) { }
                
                
            default:
                break
            }
            
        }else {
            
            switch indexPath.row {
            case 0:
                //self.scanQRBtnPressed(UIButton())
                                
                let scanner = QRCodeScannerController()
                scanner.delegate = self
                scanner.modalPresentationStyle = .overFullScreen
                self.present(scanner, animated: true, completion: nil)
            
            case 1:
                
                self.tabBarController?.tabBar.isHidden = true
                
                let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "DiagnosisModePopUpVC") as! DiagnosisModePopUpVC
                vc.isQuote = { quoteId in
                    
                    self.tabBarController?.tabBar.isHidden = false
                    
                    if quoteId != "" {
                        self.getQuoteData(quotationID: quoteId)
                    }else {
                        
                    }
                }
                self.present(vc, animated: true) { }
                
            case 2:
                let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "HelpVC") as! HelpVC
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
            
        }
        
    }
    
    //MARK:- Web Service Methods
    func showHudLoader() {
        hud.textLabel.text = ""
        hud.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7764705882, blue: 0.7568627451, alpha: 0.5)
        hud.show(in: self.view)
    }
    
    func getQuoteData(quotationID : String) {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "quoteId" : quotationID
        ]
        
        print(params)
        self.showHudLoader()
        
        let webService = AF.request(AppURL.kGetQuoteData, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        if AppDelegate.sharedDelegate().currentProductID == json["msg"]["productId"].stringValue {
                            
                            AppDelegate.sharedDelegate().insuredQuotationID = quotationID
                            
                            let vc = DesignManager.loadViewControllerFromHomeStoryBoard(identifier: "DeviceDetectVC") as! DeviceDetectVC
                            
                            vc.productName = json["msg"]["productName"].stringValue
                            vc.policyName = json["msg"]["policyName"].stringValue
                            vc.productId = json["msg"]["productId"].stringValue
                            vc.policyId = json["msg"]["policyId"].stringValue
                            vc.productImage = json["msg"]["productImage"].stringValue
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }else {
                            
                            self.showaAlert(message: self.getLocalizatioStringValue(key: "Device not matched"))
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

extension AccountTabVC: QRScannerCodeDelegate {
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("result: \(result)")
        
        AppDelegate.sharedDelegate().insuredQuotationID = result
        
        if self.reachability?.connection.description != "No Connection" {
            self.getQuoteData(quotationID: result)
        }else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
        }
        
    }

    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error: \(error)")
    }

    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
    
}

extension AccountTabVC {
    
    /*
    @IBAction func scanQRBtnPressed(_ sender: UIButton) {
    
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                
                print("result is : \(result.value)")
                //self.storeToken = String(result.value)
                //print("code is : \(self.storeToken.prefix(4))")
                
                AppDelegate.sharedDelegate().insuredQuotationID = result.value
                              
                if self.reachability?.connection.description != "No Connection" {
                    self.getQuoteData(quotationID: result.value)
                }else {
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
                }
                
            }
        }
        
        present(readerVC, animated: true, completion: nil)
    }
    
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
        
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: self.getLocalizatioStringValue(key: "Error"), message: self.getLocalizatioStringValue(key: "This app is not authorized to use Back Camera."), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: self.getLocalizatioStringValue(key: "Setting"), style: .default, handler: { (_) in
                    
                    DispatchQueue.main.async {
                        
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                
                                UIApplication.shared.open(settingsUrl, options: [:]) { (success) in
                                    
                                }
                                
                            } else {
                                // Fallback on earlier versions
                                
                                UIApplication.shared.openURL(settingsUrl)
                            }
                        }
                        
                    }
                    
                }))
                
                alert.addAction(UIAlertAction(title: self.getLocalizatioStringValue(key: "Cancel"), style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: self.getLocalizatioStringValue(key: "Error"), message: self.getLocalizatioStringValue(key: "Reader not supported by the current device"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: self.getLocalizatioStringValue(key: "OK"), style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    */
    
}
