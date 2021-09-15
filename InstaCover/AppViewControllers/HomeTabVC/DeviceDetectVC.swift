//
//  DeviceDetectVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 12/08/21.
//

import UIKit
import JGProgressHUD
import Alamofire
import SwiftyJSON
import AlamofireImage

class DeviceDetectVC: UIViewController {

    @IBOutlet weak var currentDeviceView: UIView!
    @IBOutlet weak var currentDeviceImageView: UIImageView!
    @IBOutlet weak var lblCurrentDeviceName: UILabel!
    @IBOutlet weak var lblCurrentDeviceMemory: UILabel!
    @IBOutlet weak var noDeviceView: UIView!
    @IBOutlet weak var lblNotFoundDeviceName: UILabel!
    @IBOutlet weak var lblPolicyName: UILabel!
    
    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    
    var productName : String?
    var policyName : String?
    var productId : String?
    var policyId : String?
    var productImage : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
        
        if reachability?.connection.description != "No Connection" {
            //self.getDeviceInfo()
        }else {
            //self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
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
    func setUIElements() {
        self.setStatusBarGradientColor()
        
        UIView.addShadowOnView(baseView: self.currentDeviceView)
        
        if let name = self.productName {
            self.lblCurrentDeviceName.text = name
            self.lblCurrentDeviceMemory.isHidden = true
        }
        
        if let policy = self.policyName {
            self.lblPolicyName.text = policy
        }
        
        if let img = self.productImage {
            if let imgUrl = URL.init(string: img) {
                self.currentDeviceImageView.af.setImage(withURL: imgUrl)
            }
        }
        
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedDeviceDiagnosisBtnClicked(_ sender: UIButton) {
        //self.startDiagnoseScreen()
        
        self.getQuestions()
    }
    
    //MARK:- Web Service Methods
    func showHudLoader() {
        hud.textLabel.text = ""
        hud.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7764705882, blue: 0.7568627451, alpha: 0.5)
        hud.show(in: self.view)
    }
    
    func getDeviceInfo() {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "deviceBrand" : "apple",
            "modelBrand" : "apple",
            "device" : UIDevice.current.currentModelName,
            "model" : UIDevice.current.currentModelName,
            "memory" : "",
            //"ram" : "3073741824",
            //"rom" : "256",
            "ram" : ProcessInfo.processInfo.physicalMemory,
            "rom" : UIDevice.current.systemSize!,
            "IMEI" : AppUserDefaults.value(forKey: "IMEI") ?? "",
            "uniqueId" : UIDevice.current.identifierForVendor!.uuidString,
            //"uniqueId" : UUID().uuidString,
            "uniqueType":"ios"
        ]
        
        //print(params)
        self.showHudLoader()
        
        let webService = AF.request(AppURL.kGetCurrentDevice, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        if let url = URL.init(string: json["msg"]["image"].stringValue) {
                            self.currentDeviceImageView.af.setImage(withURL: url)
                        }
                                                
                        let words = json["msg"]["name"].stringValue.byWords
                        let varient = words.last ?? ""
                        self.lblCurrentDeviceMemory.text = String.init(varient)
                        
                        var deviceName = json["msg"]["name"].stringValue
                        if let range = json["msg"]["name"].stringValue.range(of: String.init(varient)) {
                            deviceName.removeSubrange(range)
                            
                            self.lblCurrentDeviceName.text = deviceName
                        }
                        
                        AppDelegate.sharedDelegate().currentProductID = json["msg"]["id"].stringValue
                        AppDelegate.sharedDelegate().selectedProductID = json["msg"]["id"].stringValue
                        AppDelegate.sharedDelegate().selectedProductName = json["msg"]["name"].stringValue
                     
                    }else {
                        
                        //self.showaAlert(message: json["msg"].stringValue)
                        self.noDeviceView.isHidden = false
                        
                        self.lblNotFoundDeviceName.text = UIDevice.current.currentModelName
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
    
    //MARK:- Web Service getQuestions
    
    func getQuestions() {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "policyId" : self.policyId ?? ""
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

extension DeviceDetectVC {
    
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
                
                switch UIDevice.current.currentModelName {
                case "iPhone 4","iPhone 4s","iPhone 5","iPhone 5c","iPhone 5s","iPhone 6","iPhone 6 Plus","iPhone 6s","iPhone 6s Plus":
                                
                    self.EarphoneTest()
                    break
                default:
                    
                    self.ChargerTest()
                    break
                }
                
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
            "result" :  AppResultJSON
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
