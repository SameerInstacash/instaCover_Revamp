//
//  CreateCustomerRequestFormVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 09/08/21.
//

import UIKit

class CreateCustomerRequestFormVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var txtViewCollectionAddress: UITextView!
    @IBOutlet weak var txtViewReason: UITextView!

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
        
        self.txtViewCollectionAddress.delegate = self
        self.txtViewReason.delegate = self
    }
    
    //MARK: - TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type Here..." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Type Here..."
        }
    }
 
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createServiceRequestBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let vc = DesignManager.loadViewControllerFromAccountStoryBoard(identifier: "ServiceRequestSubmitVC") as! ServiceRequestSubmitVC
        self.present(vc, animated: true) { }
    }
    
    @IBAction func tncBtnClicked(_ sender: UIButton) {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
