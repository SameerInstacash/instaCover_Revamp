//
//  EditProfileDetailsVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 09/08/21.
//

import UIKit

class EditProfileDetailsVC: UIViewController {
    
    @IBOutlet weak var txtFFullName: UITextField!
    @IBOutlet weak var txtFPassport: UITextField!
    @IBOutlet weak var txtFContactNo: UITextField!
    @IBOutlet weak var txtFEmailAddress: UITextField!
    @IBOutlet weak var txtFDeviceBrand: UITextField!
    @IBOutlet weak var txtFImei: UITextField!
    @IBOutlet weak var txtFCoverageTenure: UITextField!
    @IBOutlet weak var txtFServiceRequestFee: UITextField!
    
    @IBOutlet weak var btnCancelBaseView: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUIElements()
        
        if let userData = CustomUserDefault.getUserData() {
            self.txtFFullName.text = userData.name
            self.txtFPassport.text = ""
            self.txtFContactNo.text = userData.mobile
            self.txtFEmailAddress.text = userData.email
            self.txtFDeviceBrand.text = ""
            self.txtFImei.text = AppUserDefaults.value(forKey: "IMEI") as? String ?? ""
            self.txtFCoverageTenure.text = ""
            self.txtFServiceRequestFee.text = ""
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
        
        UIView.addShadowOnViewGray(baseView: self.btnCancelBaseView)
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
    
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
