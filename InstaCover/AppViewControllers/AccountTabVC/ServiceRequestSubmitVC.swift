//
//  ServiceRequestSubmitVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 13/08/21.
//

import UIKit
import MessageUI

class ServiceRequestSubmitVC: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: IBAction
    @IBAction func doneBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true) { }
    }
    
    @IBAction func mailBtnClicked(_ sender: UIButton) {
        
        if MFMailComposeViewController.canSendMail(){
            
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["instacover@compasia.com"])
            mailVC.setSubject("Feedback")
            mailVC.setMessageBody("Email message", isHTML: false)
            self.present(mailVC, animated: true, completion: nil)
            
        }else{
            print("Can't send email")
        }
    }
    
    // MARK: - Email Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
