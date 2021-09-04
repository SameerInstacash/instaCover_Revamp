//
//  SingOutVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 07/08/21.
//

import UIKit

class SignOutVC: UIViewController {
    
    var isTabShow : ((_ isGo : Bool)->(Void))?
    
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
    @IBAction func yesBtnClicked(_ sender: UIButton) {
        if let show = self.isTabShow {
            self.dismiss(animated: true) { }
            show(true)
        }
    }
    
    @IBAction func noBtnClicked(_ sender: UIButton) {
        if let show = self.isTabShow {
            show(false)
            self.dismiss(animated: true) { }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
