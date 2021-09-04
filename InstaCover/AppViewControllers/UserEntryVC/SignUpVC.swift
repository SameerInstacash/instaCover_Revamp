//
//  SignUpVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldContact: UITextField!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.btnYes.isSelected = true
    }
    
    //MARK: Custom Methods
    func setUIElements() {
        self.setStatusBarGradientColor()
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func yesBtnClicked(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            
            self.btnNo.isSelected = false
        }else {
            sender.isSelected = !sender.isSelected
            
            self.btnNo.isSelected = true
        }
    }
    
    @IBAction func noBtnClicked(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            
            self.btnYes.isSelected = false
        }else {
            sender.isSelected = !sender.isSelected
            
            self.btnYes.isSelected = true
        }
    }
    
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromDashboardStoryBoard(identifier: "TabBarViewController") as! TabBarViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
