//
//  AccountTabVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit

class AccountTabVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var accountTableView: UITableView!
    
    var arrItem = ["Create customer request","Change password","Help","Sign out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
    }
    
    //MARK: Custom Method
    func setUIElements() {
        self.setStatusBarGradientColor()
        self.registerTableViewCells()
    }
    
    //MARK: IBAction
    @IBAction func ViewUserProfileBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "ViewProfileDetailsVC") as! ViewProfileDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Custom Method
    func registerTableViewCells() {
        self.accountTableView.register(UINib.init(nibName: "AccountUserTblCell", bundle: nil), forCellReuseIdentifier: "AccountUserTblCell")
        self.accountTableView.register(UINib.init(nibName: "AccountItemTblCell", bundle: nil), forCellReuseIdentifier: "AccountItemTblCell")
    }
    
    //MARK: UITableView DataSource & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItem.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let AccountUserTblCell = tableView.dequeueReusableCell(withIdentifier: "AccountUserTblCell", for: indexPath) as! AccountUserTblCell
            
            return AccountUserTblCell
        }else {
            let AccountItemTblCell = tableView.dequeueReusableCell(withIdentifier: "AccountItemTblCell", for: indexPath) as! AccountItemTblCell
            AccountItemTblCell.lblItemName.text = self.arrItem[indexPath.row - 1]
            
            return AccountItemTblCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1:
            let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "CreateCustomerRequestVC") as! CreateCustomerRequestVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "ChangePasswordVC") as! ChangePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "HelpVC") as! HelpVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            
            self.tabBarController?.tabBar.isHidden = true
            
            DispatchQueue.main.async {
                let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "SignOutVC") as! SignOutVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.isTabShow = {
                    self.tabBarController?.tabBar.isHidden = false
                }
                self.present(vc, animated: true) { }
            }
            
        default:
            break
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
