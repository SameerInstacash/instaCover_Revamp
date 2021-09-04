//
//  LoginVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var lblRegisterHeight: NSLayoutConstraint!
    
    var isLoggedIn : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUIElements()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isLoggedIn {
            self.lblRegisterHeight.constant = 0
        }else {
            self.lblRegisterHeight.constant = 36
        }
        
    }
    
    //MARK: Custom Methods
    func setUIElements() {
        self.setStatusBarGradientColor()
        
        UIView.addShadowOnViewThemeColor(baseView: self.btnSkip)
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func passwordEyeBtnClicked(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            
            self.txtFieldPassword.isSecureTextEntry = false
        }else {
            sender.isSelected = !sender.isSelected
            
            self.txtFieldPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func forgotPasswordBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromDashboardStoryBoard(identifier: "TabBarViewController") as! TabBarViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func skipBtnClicked(_ sender: UIButton) {
        
    }
}

