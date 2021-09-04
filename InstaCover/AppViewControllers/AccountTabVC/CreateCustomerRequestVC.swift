//
//  CreateCustomerRequestVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 07/08/21.
//

import UIKit

class CreateCustomerRequestVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var customerRequestTableView: UITableView!
    
    var arrDeviceName = ["Huawei Mate 20 128GB","iPhone 12 Pro 128GB","iPhone 11 Pro 128GB"]
    var arrServiceName = ["Extended Warranty","Replace Plus","Replace Plus"]
    var arrServiceId = ["001001","002002","003003"]
    
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
        self.registerTableViewCells()
    }
    
    //MARK: Custom Method
    func registerTableViewCells() {
        self.customerRequestTableView.register(UINib.init(nibName: "CustomerRequestTblCell", bundle: nil), forCellReuseIdentifier: "CustomerRequestTblCell")
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func CreateCustomerRequestBtnClicked(_ sender: UIButton) {
        let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "CreateCustomerRequestFormVC") as! CreateCustomerRequestFormVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: UITableView DataSource & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDeviceName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CustomerRequestTblCell = tableView.dequeueReusableCell(withIdentifier: "CustomerRequestTblCell", for: indexPath) as! CustomerRequestTblCell
                
        CustomerRequestTblCell.lblDeviceName.text = self.arrDeviceName[indexPath.row]
        CustomerRequestTblCell.lblServiceName.text = self.arrServiceName[indexPath.row]
        CustomerRequestTblCell.lblServiceID.text = self.arrServiceId[indexPath.row]
        
        return CustomerRequestTblCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
