//
//  NotificationVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 06/08/21.
//

import UIKit

class NotificationVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var notificationTableView: UITableView!
    
    var arrItemImage = [#imageLiteral(resourceName: "notification"),#imageLiteral(resourceName: "notification"),#imageLiteral(resourceName: "notification"),#imageLiteral(resourceName: "promo")]
    var arrItem1 = ["Service request has been approved!","Payment successful!","Diagnosis completed","20% promo on our care plan!"]
    var arrItem2 = ["We've received your Replace Plus service...","Enjoy the carefree experience now with...","Thanks for run this test with us...","Still haven't subscribe our care plan yet?"]
    var arrItem3 = ["3 Jul","10 May","10 May","2 May"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
    }
    
    //MARK: Custom Method
    func setUIElements() {
        //self.setStatusBarGradientColor()
        self.registerTableViewCells()
    }
    
    //MARK: Custom Method
    func registerTableViewCells() {
        self.notificationTableView.register(UINib.init(nibName: "NotificationTblCell", bundle: nil), forCellReuseIdentifier: "NotificationTblCell")
    }
    
    //MARK: UITableView DataSource & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItem1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let NotificationTblCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTblCell", for: indexPath) as! NotificationTblCell
        NotificationTblCell.iconImageVW.image = self.arrItemImage[indexPath.row]
        NotificationTblCell.lblTitle.text = self.arrItem1[indexPath.row]
        NotificationTblCell.lblSubTitle.text = self.arrItem2[indexPath.row]
        NotificationTblCell.lblDate.text = self.arrItem3[indexPath.row]
        
        return NotificationTblCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
