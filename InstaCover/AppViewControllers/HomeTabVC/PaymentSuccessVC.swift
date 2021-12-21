//
//  PaymentSuccessVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 12/08/21.
//

import UIKit
import JGProgressHUD
import Alamofire
import SwiftyJSON

class PaymentSuccessVC: UIViewController {
    
    @IBOutlet weak var congratulationView: UIView!
    @IBOutlet weak var changeMindView: UIView!
    @IBOutlet weak var successImgVW: UIImageView!
    @IBOutlet weak var lblPaymentMSG: UILabel!
    @IBOutlet weak var proceedBtnHeight: NSLayoutConstraint!

    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUIElements()
        
        if !AppDelegate.sharedDelegate().isCurrentDevice {
            //self.lblPaymentMSG.text = "Please scan below qr code to proceed device diagnosis"
            self.lblPaymentMSG.text = "Please scan below qr code to diagnose your phone to complete the InstaCover process."
            self.proceedBtnHeight.constant = 0
            //self.createQrCodeForDeivce()
            
            self.successImgVW.image = self.generateQRCode(from: AppDelegate.sharedDelegate().insuredQuotationID)
        }
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
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    func createQrCodeForDeivce() {
        // Get define string to encode
        let myString = AppDelegate.sharedDelegate().insuredQuotationID
        // Get data from the string
        let data = myString.data(using: String.Encoding.ascii)
        // Get a QR CIFilter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        // Input the data
        qrFilter.setValue(data, forKey: "inputMessage")
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return }
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
        let processedImage = UIImage(cgImage: cgImage)
        
        self.successImgVW.image = processedImage
    }
    
    func setUIElements() {
        self.setStatusBarGradientColor()
        
        UIView.addShadowOnView(baseView: self.congratulationView)
        UIView.addShadowOnView(baseView: self.changeMindView)
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func diagnosticStartBtnClicked(_ sender: UIButton) {
        //self.startDiagnoseScreen()
        
        self.getQuestions()
    }
    
    @IBAction func refundBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "CreateCustomerRequestVC") as! CreateCustomerRequestVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    //MARK:- Web Service getQuestions
    
    func getQuestions() {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "policyId" : AppDelegate.sharedDelegate().selectedPolicyID
        ]
        
        //print(params)
        self.showHudLoader()
        
        let webService = AF.request(AppURL.kGetQuestions, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        AppDelegate.sharedDelegate().isVideoRequired = json["msg"]["isVideoRequired"].stringValue
                        
                        
                        let jsonDict = try JSONSerialization.jsonObject(with: responseData.data ?? Data(), options: .mutableContainers) as? [String:Any]
                        
                        let dict = jsonDict?["msg"] as? [String:Any]
                        let questionArr = dict?["questions"] as? [String]
                        
                        arrTestsInSDK = []
                        for item in questionArr ?? [] {
                            arrTestsInSDK.append(item)
                        }
                        
                        arrHoldTestsInSDK = []
                        arrHoldTestsInSDK = arrTestsInSDK
                        
                        self.performTestsInSDK()
                                             
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

extension PaymentSuccessVC {
    
    func performTestsInSDK() {
        
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "StartDiagnoseVC") as! StartDiagnoseVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .flipHorizontal
        
        performDiagnostics = {
            DispatchQueue.main.async() {
                
                print(arrTestsInSDK.count)
                print(arrTestsInSDK)
                
            
                // 1. dead pixels
                if arrTestsInSDK.contains("dead pixels") {
                    if let ind = arrTestsInSDK.firstIndex(of: "dead pixels") {
                        arrTestsInSDK.remove(at: ind)
                        
                        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "DeadPixelsVC") as! DeadPixelsVC
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                        return
                    }
                }
                
                // 2. Screen Calibration
                if arrTestsInSDK.contains("screen") {
                    if let ind = arrTestsInSDK.firstIndex(of: ("screen")) {
                        arrTestsInSDK.remove(at: ind)
                        
                        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "ScreenCalibrationVC") as! ScreenCalibrationVC
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                        return
                    }
                }
                
                // 3. Auto Rotation
                if arrTestsInSDK.contains("auto rotation") {
                    if let ind = arrTestsInSDK.firstIndex(of: "auto rotation") {
                        arrTestsInSDK.remove(at: ind)
                        
                        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "AutoRotationVC") as! AutoRotationVC
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                        return
                    }
                }
                
                // 4. Proximity
                if arrTestsInSDK.contains("proximity") {
                    if let ind = arrTestsInSDK.firstIndex(of: "proximity") {
                        arrTestsInSDK.remove(at: ind)
                        
                        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "ProximityVC") as! ProximityVC
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                        return
                    }
                }
                
                // 5. Hardware Button
                if arrTestsInSDK.contains("device buttons") {
                    if let ind = arrTestsInSDK.firstIndex(of: "device buttons") {
                        arrTestsInSDK.remove(at: ind)
                        
                        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "VolumeButtonVC") as! VolumeButtonVC
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                        return
                    }
                }
                
                // 6. Earphone
                if arrTestsInSDK.contains("earphone") {
                    if let ind = arrTestsInSDK.firstIndex(of: "earphone") {
                        arrTestsInSDK.remove(at: ind)
                        
                        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "EarphoneVC") as! EarphoneVC
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                        return
                    }
                }
                
                // 7. Charger
                if arrTestsInSDK.contains("charger") {
                    if let ind = arrTestsInSDK.firstIndex(of: "charger") {
                        arrTestsInSDK.remove(at: ind)
                        
                        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "ChargerVC") as! ChargerVC
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                        return
                    }
                }
                
                // 8. Camera
                if arrTestsInSDK.contains("camera") {
                    if let ind = arrTestsInSDK.firstIndex(of: "camera") {
                        arrTestsInSDK.remove(at: ind)
                        
                        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "CameraVC") as! CameraVC
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                        return
                    }
                }
                
                // 9. Torch
                if arrTestsInSDK.contains("torch") {
                    if let ind = arrTestsInSDK.firstIndex(of: "torch") {
                        arrTestsInSDK.remove(at: ind)
                        
                        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "FlashLightVC") as! FlashLightVC
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                        return
                    }
                }
                
                // 10. Biometric
                if arrTestsInSDK.contains("fingerprint scanner") {
                    if let ind = arrTestsInSDK.firstIndex(of: "fingerprint scanner") {
                        arrTestsInSDK.remove(at: ind)
                        
                        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "BiometricVC") as! BiometricVC
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                        return
                    }
                }
                
                // 11. WiFi
                if arrTestsInSDK.contains("wifi") {
                    if let ind = arrTestsInSDK.firstIndex(of: "wifi") {
                        arrTestsInSDK.remove(at: ind)
                        
                        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "WiFiVC") as! WiFiVC
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                        return
                    }
                }
                
                // 12. Background
                if arrTestsInSDK.contains("gsm network") || arrTestsInSDK.contains("bluetooth") || arrTestsInSDK.contains("gps") {
                    //if let ind = arrTestsInSDK.firstIndex(of: "dead pixels") {
                        //arrTestsInSDK.remove(at: ind)
                        
                        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "BackgroundTestsVC") as! BackgroundTestsVC
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                        return
                    //}
                }
                
                if arrTestsInSDK.contains("nfc") {
                    if let ind = arrTestsInSDK.firstIndex(of: "nfc") {
                        arrTestsInSDK.remove(at: ind)
                    }
                }
                
                if arrTestsInSDK.contains("screen glass") {
                    if let ind = arrTestsInSDK.firstIndex(of: "screen glass") {
                        arrTestsInSDK.remove(at: ind)
                    }
                }
                
                if arrTestsInSDK.count == 0 {
                    print("All Tests Performed.")
                    self.TestResultScreen()
                }
                
            }
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func startDiagnoseScreen() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "StartDiagnoseVC") as! StartDiagnoseVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .flipHorizontal
        
        vc.startDiagnosis = {
            DispatchQueue.main.async() {
                self.DeadPixelTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func DeadPixelTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "DeadPixelsVC") as! DeadPixelsVC
        vc.modalPresentationStyle = .overFullScreen
        //vc.modalTransitionStyle = .flipHorizontal
        
        vc.deadPixelTestDiagnosis = {
            DispatchQueue.main.async() {
                self.touchScreenTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func touchScreenTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "ScreenCalibrationVC") as! ScreenCalibrationVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.screenTestDiagnosis = {
            DispatchQueue.main.async() {
                self.AutoRotationTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func AutoRotationTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "AutoRotationVC") as! AutoRotationVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.rotationTestDiagnosis = {
            DispatchQueue.main.async() {
                self.ProximityTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func ProximityTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "ProximityVC") as! ProximityVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.proximityTestDiagnosis = {
            DispatchQueue.main.async() {
                self.VolumeButtonTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func VolumeButtonTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "VolumeButtonVC") as! VolumeButtonVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.volumeTestDiagnosis = {
            DispatchQueue.main.async() {
                
                self.EarphoneTest()
                
                /*
                switch UIDevice.current.currentModelName {
                case "iPhone 4","iPhone 4s","iPhone 5","iPhone 5c","iPhone 5s","iPhone 6","iPhone 6 Plus","iPhone 6s","iPhone 6s Plus":
                                
                    self.EarphoneTest()
                    break
                default:
                    
                    self.ChargerTest()
                    break
                }*/
                
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func EarphoneTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "EarphoneVC") as! EarphoneVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.earphoneTestDiagnosis = {
            DispatchQueue.main.async() {
                self.ChargerTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func ChargerTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "ChargerVC") as! ChargerVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.chargerTestDiagnosis = {
            DispatchQueue.main.async() {
                self.CameraTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func CameraTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "CameraVC") as! CameraVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.cameraTestDiagnosis = {
            DispatchQueue.main.async() {
                self.BiometricTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func BiometricTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "BiometricVC") as! BiometricVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.biometricTestDiagnosis = {
            DispatchQueue.main.async() {
                self.WiFiTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func WiFiTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "WiFiVC") as! WiFiVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.wifiTestDiagnosis = {
            DispatchQueue.main.async() {
                self.BackgroundTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func BackgroundTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "BackgroundTestsVC") as! BackgroundTestsVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.backgroundTestDiagnosis = {
            DispatchQueue.main.async() {
                self.TestResultScreen()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func TestResultScreen() {
        
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "DiagnosticTestResultVC") as! DiagnosticTestResultVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.testResultTestDiagnosis = {
            DispatchQueue.main.async() {
                print(AppResultJSON)
                print(AppResultString)
                
                self.saveStoreResult()
            }
        }
        self.present(vc, animated: true, completion: nil)
                
    }
    
    
    //MARK:- Web Service Methods
    func showHudLoader() {
        hud.textLabel.text = ""
        hud.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7764705882, blue: 0.7568627451, alpha: 0.5)
        hud.show(in: self.view)
    }
    
    func saveStoreResult() {
        
        let jsonObject: Any  = [
          "Camera" : 1,
          "Rotation" : 1,
          "Screen" : 1,
          "Dead Pixels" : 1,
          "Bluetooth" : 1,
          "GSM" : 1,
          "GPS" : 1,
          "Vibrator" : 1,
          "Fingerprint Scanner" : 1,
          "Hardware Buttons" : 1,
          "Battery" : 1,
          "USB" : 1,
          "WIFI" : 1,
          "Microphone" : 1,
          "Proximity" : 1,
          "Speakers" : 1,
          "Autofocus" : 1,
          "Storage" : 1
        ]
        print(jsonObject)
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "quotationId" : AppDelegate.sharedDelegate().insuredQuotationID,
            "result" : AppResultJSON
        ]
        
        //print(params)
        self.showHudLoader()
        
        let webService = AF.request(AppURL.kStoreResult, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if AppDelegate.sharedDelegate().isVideoRequired == "1" {
                        
                        if json["status"] == "Success" {
                            
                            let vc = DesignManager.loadViewControllerFromInstacashSDKStoryBoard(identifier: "AlternateEmailVC") as! AlternateEmailVC
                            
                            vc.isDismiss = { email in
                                
                                let vc = DesignManager.loadViewControllerFromInstacashSDKStoryBoard(identifier: "UploadVideoVC") as! UploadVideoVC
                                vc.userEmail = email
                                
                                vc.isDismiss = {
                                    
                                    let vc1 = DesignManager.loadViewControllerFromInstacashSDKStoryBoard(identifier: "EligibleVC") as! EligibleVC
                                    vc1.isDismiss = {
                                        let vc = DesignManager.loadViewControllerFromDashboardStoryBoard(identifier: "HomeTabVC") as! HomeTabVC
                                        vc.tabBarController?.tabBar.isHidden = false
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    self.present(vc1, animated: true, completion: nil)
                                    
                                }
                                
                                self.present(vc, animated: true, completion: nil)
                            }
                            
                            self.present(vc, animated: true, completion: nil)
                            
                        }else {
                            
                            let vc = DesignManager.loadViewControllerFromInstacashSDKStoryBoard(identifier: "AlternateEmailVC") as! AlternateEmailVC
                            
                            vc.isDismiss = { email in
                                
                                let vc = DesignManager.loadViewControllerFromInstacashSDKStoryBoard(identifier: "UploadVideoVC") as! UploadVideoVC
                                vc.userEmail = email
                                
                                vc.isDismiss = {
                                    
                                    let vc2 = DesignManager.loadViewControllerFromInstacashSDKStoryBoard(identifier: "NotEligibleVC") as! NotEligibleVC
                                    vc2.isDismiss = {
                                        let vc = DesignManager.loadViewControllerFromDashboardStoryBoard(identifier: "HomeTabVC") as! HomeTabVC
                                        vc.tabBarController?.tabBar.isHidden = false
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    self.present(vc2, animated: true, completion: nil)
                                    
                                }
                                
                                self.present(vc, animated: true, completion: nil)
                            }
                            
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                        
                    }else {
                        if json["status"] == "Success" {
                            
                            let vc1 = DesignManager.loadViewControllerFromInstacashSDKStoryBoard(identifier: "EligibleVC") as! EligibleVC
                            vc1.isDismiss = {
                                let vc = DesignManager.loadViewControllerFromDashboardStoryBoard(identifier: "HomeTabVC") as! HomeTabVC
                                vc.tabBarController?.tabBar.isHidden = false
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            self.present(vc1, animated: true, completion: nil)
                                                 
                        }else {
                            
                            let vc2 = DesignManager.loadViewControllerFromInstacashSDKStoryBoard(identifier: "NotEligibleVC") as! NotEligibleVC
                            vc2.isDismiss = {
                                
                                let vc = DesignManager.loadViewControllerFromDashboardStoryBoard(identifier: "HomeTabVC") as! HomeTabVC
                                vc.tabBarController?.tabBar.isHidden = false
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            self.present(vc2, animated: true, completion: nil)
                            
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

}
