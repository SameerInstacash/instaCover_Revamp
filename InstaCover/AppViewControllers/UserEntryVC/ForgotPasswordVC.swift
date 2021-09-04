//
//  ForgotPasswordVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
    }
    
    //MARK: Custom Methods
    func setUIElements() {
        self.setStatusBarGradientColor()
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgotPasswordBtnClicked(_ sender: UIButton) {
        
    }
 
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromMainStoryBoard(identifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
