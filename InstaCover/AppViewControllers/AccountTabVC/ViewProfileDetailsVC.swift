//
//  ViewProfileDetailsVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 07/08/21.
//

import UIKit

class ViewProfileDetailsVC: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPassport: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var lblDevieceBrand: UILabel!
    @IBOutlet weak var lblImei: UILabel!
    @IBOutlet weak var lblCoverageTenure: UILabel!
    @IBOutlet weak var lblServiceRequestFee: UILabel!
    @IBOutlet weak var lblServiceRequestSubmission: UILabel!
    @IBOutlet weak var lblSelectedRequestStatus: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
        
        if let userData = CustomUserDefault.getUserData() {
            self.lblName.text = userData.name
            self.lblPassport.text = ""
            self.lblContactNo.text = userData.mobile
            self.lblEmailAddress.text = userData.email
            self.lblDevieceBrand.text = ""
            self.lblImei.text = AppUserDefaults.value(forKey: "IMEI") as? String ?? ""
            self.lblCoverageTenure.text = ""
            self.lblServiceRequestFee.text = ""
            self.lblServiceRequestSubmission.text = ""
            self.lblSelectedRequestStatus.text = ""
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
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "EditProfileDetailsVC") as! EditProfileDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
