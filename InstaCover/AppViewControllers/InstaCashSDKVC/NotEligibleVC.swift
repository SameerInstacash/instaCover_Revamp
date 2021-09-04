//
//  NotEligibleVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 12/08/21.
//

import UIKit

class NotEligibleVC: UIViewController {
    
    @IBOutlet weak var notEligibleImageView: UIImageView!
    
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
        self.notEligibleImageView.loadGif(name: "Not_Eligible")
    }
    
    //MARK: IBAction
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true) { }
    }
    
    @IBAction func claimRequestBtnClicked(_ sender: UIButton) {
    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
