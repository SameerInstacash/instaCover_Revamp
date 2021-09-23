//
//  AlternateEmailVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 06/09/21.
//

import UIKit

class AlternateEmailVC: UIViewController {

    @IBOutlet weak var txtFieldAlternateEmail: UITextField!
    
    var isDismiss : ((_ email:String) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if let userData = CustomUserDefault.getUserData() {
            self.txtFieldAlternateEmail.text = userData.email ?? ""
        }
        
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        
        if self.txtFieldAlternateEmail.text?.isEmpty ?? false {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter email"))
            
        }else if !(self.isValidEmail(self.txtFieldAlternateEmail.text ?? "")) {
            
            self.showaAlert(message: self.getLocalizatioStringValue(key: "please enter valid email"))
            
        }else {
            
            self.dismiss(animated: true) { }
            if let dismiss = self.isDismiss {
                dismiss(self.txtFieldAlternateEmail.text ?? "")
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
