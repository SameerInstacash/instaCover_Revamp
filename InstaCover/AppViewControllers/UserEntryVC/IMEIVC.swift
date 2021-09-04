//
//  IMEIVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 13/08/21.
//

import UIKit

class IMEIVC: UIViewController {
    
    @IBOutlet weak var txtFieldIMEI: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
        
        if AppUserDefaults.value(forKey: "IMEI") != nil {
            self.goToLoginVC()
        }
    }
    
    //MARK: Custom Methods
    func setUIElements() {
        self.setStatusBarGradientColor()
    }
    
    //MARK: IBAction
    @IBAction func continueBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.txtFieldIMEI.text?.isEmpty ?? false {
            self.showaAlert(message: "Please enter vaild IMEI number.")
        }else if self.txtFieldIMEI.text?.count != 15  {
            self.showaAlert(message: "Please enter vaild IMEI number.")
        }else {
            AppUserDefaults.setValue(self.txtFieldIMEI.text, forKey: "IMEI")
            
            self.goToLoginVC()
        }
    }
    
    func goToLoginVC() {
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
