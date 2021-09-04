//
//  DiagnosisModePopUpVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 03/09/21.
//

import UIKit

class DiagnosisModePopUpVC: UIViewController {

    @IBOutlet weak var txtFieldDiagnosisCode: UITextField!
    var isQuote : ((_ quoteID : String)->(Void))?
    
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
    }
    
    //MARK: IBAction
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        
        guard !(self.txtFieldDiagnosisCode.text?.isEmpty ?? false) else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please enter diagnosis code"))
            
            return
        }
        
        if let show = self.isQuote {
            self.dismiss(animated: true) { }
            show(self.txtFieldDiagnosisCode.text ?? "")
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        if let show = self.isQuote {
            show("")
            self.dismiss(animated: true) { }
        }
    }
}
