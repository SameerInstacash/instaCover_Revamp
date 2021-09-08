//
//  HomeTabVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit
import JGProgressHUD
import Alamofire
import SwiftyJSON
import iOSDropDown

class HomeTabVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var aboutCollectionView: UICollectionView!
    @IBOutlet weak var planCollectionView: UICollectionView!
    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var deviceModelView: UIView!
    @IBOutlet weak var deviceTenureView: UIView!
    @IBOutlet weak var noDeviceView: UIView!
    
    @IBOutlet weak var btnExtWarrantyBaseView: UIView!
    @IBOutlet weak var btnReplacePlusBaseView: UIView!
    @IBOutlet weak var btnExtWarrantyBase: UIButton!
    @IBOutlet weak var btnReplacePlusBase: UIButton!
    @IBOutlet weak var btnExtWarranty: UIButton!
    @IBOutlet weak var btnReplacePlus: UIButton!
    @IBOutlet weak var btnSelectDeviceModel: UIButton!
    @IBOutlet weak var btnSelectTenure: UIButton!
    
    @IBOutlet weak var btnMyDevice: UIButton!
    @IBOutlet weak var btnMyDeviceHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDetectedDevice: UILabel!
    @IBOutlet weak var currentDeviceImageView: UIImageView!
    @IBOutlet weak var lblCurrentDeviceName: UILabel!
    @IBOutlet weak var lblCurrentDeviceVarient: UILabel!
    @IBOutlet weak var lblSelectedPlanFee: UILabel!
    @IBOutlet weak var lblSelectedPlanTax: UILabel!
    @IBOutlet weak var lblNotFoundDeviceName: UILabel!
    
    @IBOutlet weak var txtFieldDeviceModel: DropDown!
    @IBOutlet weak var txtFieldTenure: DropDown!
    
    @IBOutlet weak var featureTableView: UITableView!
    @IBOutlet weak var heightOfFeatureTableView: NSLayoutConstraint!
    
    var arrAboutImage = [#imageLiteral(resourceName: "openForAll"),#imageLiteral(resourceName: "fastApplication"),#imageLiteral(resourceName: "supportTeam"),#imageLiteral(resourceName: "flexibility")]
    var arrAboutTitle = ["OPEN FOR ALL","FAST APPLICATION","SUPPORT TEAM","FLEXIBILITY"]
    var arrAboutSubTitle = ["No restriction on customer profiles","No supporting documents required","Dedicated customer service officers","Wide selection of models accepted"]
    
    var arrPlan = [Msg]()
    var arrProducts = [Products]()
    var arrDropDevice = [String]()
    var arrDropTenure = [String]()
    var selectedPlanIndex = 0
    var isInsured = true
        
    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    
    // variable to save the last position visited, default to zero
    private var lastContentOffset: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUIElements()
        
        if reachability?.connection.description != "No Connection" {
            self.getPlanInfo()
            //self.getDeviceInfo()
            self.getAllProduct()
        }else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
        }
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.baseScrollView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.featureTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
        self.featureTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move up
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
           // move down
        }

        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
        //print(self.lastContentOffset)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        
        if self.txtFieldDeviceModel.isSelected && self.lastContentOffset < 200 {
            self.view.frame.origin.y = -100
        }
        
        if self.txtFieldTenure.isSelected {
            
            if self.lastContentOffset == 0 {
                self.view.frame.origin.y = -300
            }else if self.lastContentOffset > 0 && self.lastContentOffset < 50 {
                self.view.frame.origin.y = -250
            }else if self.lastContentOffset > 50 && self.lastContentOffset < 100 {
                self.view.frame.origin.y = -200
            }else if self.lastContentOffset > 100 && self.lastContentOffset < 150 {
                self.view.frame.origin.y = -150
            }else if self.lastContentOffset > 150 && self.lastContentOffset < 200 {
                self.view.frame.origin.y = -100
            }else if self.lastContentOffset > 200 && self.lastContentOffset < 250 {
                self.view.frame.origin.y = -50
            }
            
        }
     
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
    }
    
    //MARK: Custom Method
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                self.heightOfFeatureTableView.constant = newsize.height + 10.0
            }
        }
    }
        
    //MARK: Custom Method
    func setUIElements() {
        
        self.txtFieldTenure.delegate = self
        //self.txtFieldDeviceModel.delegate = self
        
        self.btnExtWarranty.isSelected = true
        
        self.setStatusBarGradientColor()
        self.registerTableViewCells()
        
        UIView.addShadowOnView(baseView: self.deviceView)
        
        UIView.addShadowOnViewThemeColor(baseView: self.deviceModelView)
        UIView.addShadowOnViewThemeColor(baseView: self.deviceTenureView)
        UIView.addShadowOnViewThemeColor(baseView: self.btnExtWarrantyBaseView)
        UIView.addShadowOnViewThemeColor(baseView: self.btnReplacePlusBaseView)
        
        
        // The the Closure returns Selected Index and String
        self.txtFieldDeviceModel.didSelect{(selectedText , index ,id) in
            self.txtFieldDeviceModel.text = selectedText
            
            // OTHER DEVICE SELECTED
            if AppDelegate.sharedDelegate().currentProductID != self.arrProducts[index].internalIdentifier {
                self.btnMyDeviceHeight.constant = 30
                self.lblDetectedDevice.text = "Other Device Select"
                self.currentDeviceImageView.image = #imageLiteral(resourceName: "Phone")
                self.lblCurrentDeviceName.text = selectedText
                self.lblCurrentDeviceVarient.text = ""
                
                AppDelegate.sharedDelegate().isCurrentDevice = false
                
                self.txtFieldTenure.text = self.arrDropTenure[0]
            }else {
                AppDelegate.sharedDelegate().isCurrentDevice = true
            }
            
            AppDelegate.sharedDelegate().selectedProductName = selectedText
            AppDelegate.sharedDelegate().selectedProductBrand = self.arrProducts[index].brandname ?? ""
            AppDelegate.sharedDelegate().selectedProductID = self.arrProducts[index].internalIdentifier ?? ""
            
            self.isInsured = true
            self.noDeviceView.isHidden = true
            
            self.txtFieldTenure.optionArray = self.arrDropTenure
            self.getEstimate()
            
        }
        
        self.txtFieldTenure.listWillAppear {
            if !self.isInsured {
                self.view.endEditing(true)
                
                self.showAlert(title: "", message: "Please select other device from device list", alertButtonTitles: ["OK"], alertButtonStyles: [.default], vc: self) { ind in
                    self.txtFieldTenure.hideList()
                }
            }
        }
        
        self.txtFieldTenure.didSelect{(selectedText , index ,id) in
            self.txtFieldTenure.text = selectedText
            
            AppDelegate.sharedDelegate().selectedTerm = selectedText
            AppDelegate.sharedDelegate().selectedPolicyID = self.arrPlan[self.selectedPlanIndex].terms?[index].internalIdentifier ?? ""
            AppDelegate.sharedDelegate().faqHtml = self.arrPlan[self.selectedPlanIndex].terms?[index].faq ?? ""
            AppDelegate.sharedDelegate().tncHtml = self.arrPlan[self.selectedPlanIndex].terms?[index].tnc ?? ""
            AppDelegate.sharedDelegate().descriptionHtml = self.arrPlan[self.selectedPlanIndex].terms?[index].descriptionValue ?? ""
            
            self.getEstimate()
        }
        
    }
    
    func registerTableViewCells() {
        self.aboutCollectionView.register(UINib.init(nibName: "HomeAboutCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeAboutCVCell")
        
        self.featureTableView.register(UINib.init(nibName: "FeatureTblCell", bundle: nil), forCellReuseIdentifier: "FeatureTblCell")
        
    }

    //MARK: IBAction
    @IBAction func myDeviceBtnClicked(_ sender: UIButton) {
        self.getDeviceInfo()
    }
    
    @IBAction func deviceModelBtnClicked(_ sender: UIButton) {
        /*
        let existingFileDropDown = DropDown()
        existingFileDropDown.anchorView = sender
        existingFileDropDown.cellHeight = 44
        existingFileDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        let typeOfFileArray = self.arrDropDevice
        existingFileDropDown.dataSource = typeOfFileArray
        
        // Action triggered on selection
     
        existingFileDropDown.selectionAction = { [unowned self] (index, item) in
            sender.setTitle(item, for: .normal)
        }
        existingFileDropDown.show()
        */
    }
    
    @IBAction func tenureBtnClicked(_ sender: UIButton) {
        /*
        let existingFileDropDown = DropDown()
        existingFileDropDown.anchorView = sender
        existingFileDropDown.cellHeight = 44
        existingFileDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        let typeOfFileArray = self.arrDropTenure
        existingFileDropDown.dataSource = typeOfFileArray
        
        // Action triggered on selection
     
        existingFileDropDown.selectionAction = { [unowned self] (index, item) in
            sender.setTitle(item, for: .normal)
        }
        existingFileDropDown.show()
        */
    }
    
    @IBAction func extendedWarrantyBtnClicked(_ sender: UIButton) {
        
        self.btnExtWarrantyBase.isHidden = false
        self.btnReplacePlusBase.isHidden = true
        self.btnExtWarrantyBaseView.isHidden = true
        self.btnReplacePlusBaseView.isHidden = false
        
        self.btnExtWarranty.isSelected = true
        self.btnReplacePlus.isSelected = false
        
        self.arrDropTenure = []
        for tm in self.arrPlan[0].terms ?? [] {
            self.arrDropTenure.append(tm.term ?? "")
        }
        
        //self.btnSelectTenure.setTitle(self.arrDropTenure[0], for: .normal)
        
        self.txtFieldTenure.optionArray = self.arrDropTenure
        self.txtFieldTenure.text = self.arrDropTenure[0]
        
    }
    
    @IBAction func replacePlusBtnClicked(_ sender: UIButton) {
        
        self.btnExtWarrantyBase.isHidden = true
        self.btnReplacePlusBase.isHidden = false
        self.btnExtWarrantyBaseView.isHidden = false
        self.btnReplacePlusBaseView.isHidden = true
        
        self.btnExtWarranty.isSelected = false
        self.btnReplacePlus.isSelected = true
        
        self.arrDropTenure = []
        for tm in self.arrPlan[1].terms ?? [] {
            self.arrDropTenure.append(tm.term ?? "")
        }
        
        //self.btnSelectTenure.setTitle(self.arrDropTenure[0], for: .normal)
        
        self.txtFieldTenure.optionArray = self.arrDropTenure
        self.txtFieldTenure.text = self.arrDropTenure[0]
        
    }
    
    @IBAction func readMoreBtnClicked(_ sender: UIButton) {
                
        //self.scanQRBtnPressed(sender)
    }
    
    @IBAction func proceedPaymentBtnClicked(_ sender: UIButton) {
        
        if let login = AppUserDefaults.value(forKey: "isLogin") as? Bool {
            
            if login {
                
                if isInsured {
                    if self.txtFieldDeviceModel.text != "brand & model" && AppDelegate.sharedDelegate().isCurrentDevice {
                        
                        // Show PopUp
                        self.showAlert(title: "", message: "Insured your current device", alertButtonTitles: ["No","Yes"], alertButtonStyles: [.cancel,.default], vc: self) { Index in
                           
                            if Index == 0 {
                                AppDelegate.sharedDelegate().isCurrentDevice = false
                                self.goToPaymentScreen()
                            }else {
                                AppDelegate.sharedDelegate().isCurrentDevice = true
                                self.goToPaymentScreen()
                            }
                        }
                        
                    }else {
                        self.goToPaymentScreen()
                    }
                    
                }else {
                    self.showaAlert(message: "Please select other device from device list")
                }
                
            }else {
                self.tabBarController?.tabBar.isHidden = true
                let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "LoginVC") as! LoginVC
                vc.isLoggedIn = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
    }
    
    func goToPaymentScreen() {
        let vc = DesignManager.loadViewControllerFromHomeStoryBoard(identifier: "PaymentDetailVC") as! PaymentDetailVC
        vc.arrDropCoverageTenure = self.arrDropTenure
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func leftArrowBtnClicked(_ sender: UIButton) {
        let collectionBounds = self.aboutCollectionView.bounds
        let contentOffset = CGFloat(floor(self.aboutCollectionView.contentOffset.x - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    @IBAction func rightArrowBtnClicked(_ sender: UIButton) {
        let collectionBounds = self.aboutCollectionView.bounds
        let contentOffset = CGFloat(floor(self.aboutCollectionView.contentOffset.x + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    //MARK: UITableView DataSource & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPlan[self.selectedPlanIndex].feature?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let FeatureTblCell = tableView.dequeueReusableCell(withIdentifier: "FeatureTblCell") as! FeatureTblCell
        let featureName = self.arrPlan[self.selectedPlanIndex].feature?[indexPath.item]
        
        FeatureTblCell.lblFeature.text = featureName
        
        return FeatureTblCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: UICollectonView DataSource & Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.aboutCollectionView {
            return 1
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.aboutCollectionView {
            return self.arrAboutTitle.count
        }else {
            return self.arrPlan.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.aboutCollectionView {
            let HomeAboutCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeAboutCVCell", for: indexPath) as! HomeAboutCVCell
            HomeAboutCVCell.layer.cornerRadius = 10.0
            
            HomeAboutCVCell.aboutIconImgView.image = self.arrAboutImage[indexPath.item]
            HomeAboutCVCell.lblAboutTitle.text = self.arrAboutTitle[indexPath.item]
            HomeAboutCVCell.lblAboutSubTitle.text = self.arrAboutSubTitle[indexPath.item]
            
            return HomeAboutCVCell
        }else {
            let PlanCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanCVCell", for: indexPath)
            PlanCVCell.layer.cornerRadius = 10.0
            
            let iconImgVW : UIImageView = PlanCVCell.viewWithTag(10) as! UIImageView
            let lblPlanName : UILabel = PlanCVCell.viewWithTag(20) as! UILabel
            let baseBtn : UIButton = PlanCVCell.viewWithTag(30) as! UIButton
            let baseView : UIView = PlanCVCell.viewWithTag(40)!
            
            UIView.addShadowOnViewThemeColor(baseView: baseView)
            
            let planData = self.arrPlan[indexPath.item]
            let iconData = planData.icons
            
            if indexPath.item == self.selectedPlanIndex {
                baseBtn.isHidden = false
                lblPlanName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                baseView.isHidden = true
                
                if let url = URL.init(string: iconData?.active ?? "") {
                    iconImgVW.af.setImage(withURL: url)
                }
            }else {
                baseBtn.isHidden = true
                lblPlanName.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                baseView.isHidden = false
                
                if let url = URL.init(string: iconData?.deactive ?? "") {
                    iconImgVW.af.setImage(withURL: url)
                }
            }
            
            lblPlanName.text = self.arrPlan[indexPath.item].name
            return PlanCVCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        if collectionView == self.aboutCollectionView {
            
        }else {
            
            if isInsured {
                self.selectedPlanIndex = indexPath.item
                
                self.arrDropTenure = []
                for tm in self.arrPlan[self.selectedPlanIndex].terms ?? [] {
                    self.arrDropTenure.append(tm.term ?? "")
                }
                self.txtFieldTenure.optionArray = self.arrDropTenure
                self.txtFieldTenure.text = self.arrDropTenure[0]
                
                AppDelegate.sharedDelegate().insurance = self.arrPlan[self.selectedPlanIndex].name ?? ""
                AppDelegate.sharedDelegate().selectedTerm = self.arrPlan[self.selectedPlanIndex].terms?[0].term ?? ""
                AppDelegate.sharedDelegate().selectedPolicyID = self.arrPlan[self.selectedPlanIndex].terms?[0].internalIdentifier ?? ""
                
                self.planCollectionView.reloadData()
                
                self.featureTableView.reloadData()
                //self.featureTableView.dataSource = self
                //self.featureTableView.delegate = self
                
                self.getEstimate()
            }else {
                
                self.showaAlert(message: "Please select other device from device list")
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.aboutCollectionView {
            return CGSize.init(width: collectionView.bounds.height, height: collectionView.bounds.height)
        }else {
            return CGSize.init(width: collectionView.bounds.width/2, height: collectionView.bounds.height)
        }
        
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.aboutCollectionView.contentOffset.y ,width : self.aboutCollectionView.frame.width,height : self.aboutCollectionView.frame.height)
        self.aboutCollectionView.scrollRectToVisible(frame, animated: true)
    }
    
    //MARK:- UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        if textField == self.txtFieldTenure {
            if !isInsured {
                self.showaAlert(message: "Please select other device from device list")
            }
        }else {
            
        }
    }
    
    //MARK:- Web Service Methods
    func showHudLoader() {
        hud.textLabel.text = ""
        hud.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7764705882, blue: 0.7568627451, alpha: 0.5)
        hud.show(in: self.view)
    }
    
    func getPlanInfo() {
      
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "deviceBrand" : "Apple",
            "modelBrand" : ""
        ]
        
        //print("params = \(params)")
        self.showHudLoader()
        
        let webService = AF.request(AppURL.kGetAllPlans, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let response = try JSON(data: responseData.data ?? Data())
                    print(response)
                    
                    if response["status"] == "Success" {
                        
                        let result = PlanInfo.init(json: response)
                        
                        self.arrPlan = result.msg ?? []
                        
                        AppDelegate.sharedDelegate().insurance = self.arrPlan[0].name ?? ""
                        AppDelegate.sharedDelegate().selectedTerm = self.arrPlan[0].terms?[0].term ?? ""
                        AppDelegate.sharedDelegate().selectedPolicyID = self.arrPlan[0].terms?[0].internalIdentifier ?? ""
                        
                        AppDelegate.sharedDelegate().faqHtml = self.arrPlan[0].terms?[0].faq ?? ""
                        AppDelegate.sharedDelegate().tncHtml = self.arrPlan[0].terms?[0].tnc ?? ""
                        AppDelegate.sharedDelegate().descriptionHtml = self.arrPlan[0].terms?[0].descriptionValue ?? ""
                                                
                        
                        for tm in self.arrPlan[0].terms ?? [] {
                            self.arrDropTenure.append(tm.term ?? "")
                        }
                        
                        //self.btnSelectTenure.setTitle(self.arrDropTenure[0], for: .normal)
                        self.txtFieldTenure.text = self.arrDropTenure[0]
                        
                        
                        // The list of array to display. Can be changed dynamically
                        self.txtFieldTenure.optionArray = self.arrDropTenure
                        
                        self.planCollectionView.reloadData()
                        
                        //self.featureTableView.reloadData()
                        self.featureTableView.dataSource = self
                        self.featureTableView.delegate = self
                        
                        self.getDeviceInfo()
                        
                    }else {
                        self.showaAlert(message: response["msg"].stringValue)
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
            //"rom" : "128",
            "ram" : ProcessInfo.processInfo.physicalMemory,
            "rom" : UIDevice.current.systemSize!,
            "IMEI" : AppUserDefaults.value(forKey: "IMEI") ?? "",
            "uniqueId" : UIDevice.current.identifierForVendor!.uuidString,
            //"uniqueId" : UUID().uuidString,
            "uniqueType" : "ios"
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
                        
                        self.txtFieldDeviceModel.text = "brand & model"
                        self.lblDetectedDevice.text = "Detected Device Model"
                        self.btnMyDeviceHeight.constant = 0
                        
                        if let url = URL.init(string: json["msg"]["image"].stringValue) {
                            self.currentDeviceImageView.af.setImage(withURL: url)
                        }
                                                
                        let words = json["msg"]["name"].stringValue.byWords
                        let varient = words.last ?? ""
                        self.lblCurrentDeviceVarient.text = String.init(varient)
                        
                        var deviceName = json["msg"]["name"].stringValue
                        if let range = json["msg"]["name"].stringValue.range(of: String.init(varient)) {
                            deviceName.removeSubrange(range)
                            
                            self.lblCurrentDeviceName.text = deviceName
                        }
                        
                        AppDelegate.sharedDelegate().currentProductID = json["msg"]["id"].stringValue
                        AppDelegate.sharedDelegate().selectedProductID = json["msg"]["id"].stringValue
                        AppDelegate.sharedDelegate().selectedProductName = json["msg"]["name"].stringValue
                        
                        self.isInsured = true
                        AppDelegate.sharedDelegate().isCurrentDevice = true
                        
                        self.getEstimate()
                        
                    }else {
                        //self.showaAlert(message: json["msg"].stringValue)
                        
                        self.txtFieldDeviceModel.text = "brand & model"
                        
                        self.btnMyDeviceHeight.constant = 0
                        
                        self.isInsured = false
                        AppDelegate.sharedDelegate().isCurrentDevice = false
                        
                        self.noDeviceView.isHidden = false
                        self.lblSelectedPlanFee.text = AppCurrency + " 0"
                        self.lblSelectedPlanTax.text = "Incl. 0% tax"
                        
                        self.txtFieldTenure.text = "tenure"
                        self.txtFieldTenure.optionArray = []
                        
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
    
    func getAllProduct() {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover"
        ]
        
        //print("params = \(params)")
        self.showHudLoader()
        
        let webService = AF.request(AppURL.kGetAllProduct, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let response = try JSON(data: responseData.data ?? Data())
                    
                    if response["status"] == "Success" {
                        
                        let result = AllProducts.init(json: response)
                        //print(result)
                        
                        self.arrProducts = result.productMsg ?? []
                        
                        for product in self.arrProducts {
                            self.arrDropDevice.append(product.productName ?? "")
                        }
                        
                        // The list of array to display. Can be changed dynamically
                        self.txtFieldDeviceModel.optionArray = self.arrDropDevice
                        
                    }else {
                        self.showaAlert(message: response["msg"].stringValue)
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
    
    func getEstimate() {
        
        let userData = CustomUserDefault.getUserData()
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover",
            "customerId" : userData?.internalIdentifier ?? "",
            "productId" : AppDelegate.sharedDelegate().selectedProductID,
            "policyId" : AppDelegate.sharedDelegate().selectedPolicyID,
            "uniqueId" : UIDevice.current.identifierForVendor!.uuidString,
            "uniqueType" : "ios",
            "fcmId" : "",
            "imeiNumber" : AppUserDefaults.value(forKey: "IMEI") as? String ?? ""
        ]
        
        //print("params = \(params)")
        //self.showHudLoader()
        
        let webService = AF.request(AppURL.kGetQuote, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let response = try JSON(data: responseData.data ?? Data())
                    
                    if response["status"] == "Success" {
                                                
                        //AppDelegate.sharedDelegate().insuredQuotationID = response["msg"]["quotationId"].stringValue
                        //AppDelegate.sharedDelegate().insuredAmount = response["msg"]["insured"]["amount"].string ?? "0"
                        //AppDelegate.sharedDelegate().insuredServiceFee = response["msg"]["insured"]["serviceFee"].string ?? "0"
                        
                        AppDelegate.sharedDelegate().insuredAmount = response["msg"]["amount"].string ?? "0"
                        AppDelegate.sharedDelegate().insuredServiceFee = response["msg"]["serviceFee"].string ?? "0"
                        
                        self.lblSelectedPlanFee.text = AppCurrency + " " + AppDelegate.sharedDelegate().insuredAmount
                        self.lblSelectedPlanTax.text = "Incl. \(response["msg"]["taxFee"].stringValue)% tax"
                        
                    }else {
                        self.showaAlert(message: response["msg"].stringValue)
                        
                        self.lblSelectedPlanFee.text = AppCurrency + " " + "0"
                        self.lblSelectedPlanTax.text = "Incl. 0% tax"
                    }
                    
                }catch {
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "JSON Exception"))
                    
                    self.lblSelectedPlanFee.text = AppCurrency + " " + "0"
                    self.lblSelectedPlanTax.text = "Incl. 0% tax"
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


