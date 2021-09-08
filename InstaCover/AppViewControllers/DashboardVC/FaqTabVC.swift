//
//  FaqTabVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit
import JGProgressHUD
import Alamofire
import SwiftyJSON
import AlamofireImage
import WebKit
import MessageUI

class FaqTabVC: UIViewController, UITableViewDataSource, UITableViewDelegate, WKUIDelegate, WKNavigationDelegate, MFMailComposeViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var planCollectionView: UICollectionView!
    @IBOutlet weak var faqTableView: UITableView!
    @IBOutlet weak var heightOfFaqTableView: NSLayoutConstraint!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var btnExtWarranty: UIButton!
    @IBOutlet weak var btnReplacePlus: UIButton!
    
    var faqMessage : FaqMsg?
    var arrPlan = [FaqData]()
    var selectedPlanIndex = 0
        
    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUIElements()
        
        if reachability?.connection.description != "No Connection" {
            self.getFaqData()
        }else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.faqTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.faqTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    //MARK: Custom Method
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                self.heightOfFaqTableView.constant = newsize.height + 10.0
            }
        }
    }
    
    func setUIElements() {
        self.btnExtWarranty.isSelected = true
        self.btnExtWarranty.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.9647058824, blue: 0.6745098039, alpha: 1)
        
        self.setStatusBarGradientColor()
        self.registerTableViewCells()
        self.setLeftPaddingOnTextField(self.questionTextField)
    }
    
    func setLeftPaddingOnTextField(_ tf: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: tf.frame.size.height))
        
        let searchIcon = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
        searchIcon.image = #imageLiteral(resourceName: "searchGray")
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.center = paddingView.center
        paddingView.addSubview(searchIcon)
        
        tf.leftView = paddingView
        tf.leftViewMode = .always
    }
    
    //MARK: Custom Method
    func registerTableViewCells() {
        self.faqTableView.register(UINib.init(nibName: "FaqQuestionTblCell", bundle: nil), forCellReuseIdentifier: "FaqQuestionTblCell")
        self.faqTableView.register(UINib.init(nibName: "FaqAnswerTblCell", bundle: nil), forCellReuseIdentifier: "FaqAnswerTblCell")
    }
        
    //MARK: IBAction
    @IBAction func faqQuestionsPlusMinusBtnClicked(_ sender: UIButton) {
        
        guard let cell = sender.superview?.superview?.superview as? FaqQuestionTblCell else {
            return // or fatalError() or whatever
        }
        
        
        let indexPath = self.faqTableView.indexPath(for: cell)
        let model = self.faqMessage?.faqData?[self.selectedPlanIndex].faq?[indexPath?.section ?? 0]
        
        //model?.isCollapsable = !(model?.isCollapsable ?? false)
        
        self.faqMessage?.faqData?[self.selectedPlanIndex].faq?[indexPath?.section ?? 0].isCollapsable = !(model?.isCollapsable ?? false)
       
        
        self.faqTableView.performBatchUpdates {
            
            self.faqTableView.beginUpdates()
            self.faqTableView.reloadSections(IndexSet.init(integer: indexPath?.section ?? 0), with: .fade)
            self.faqTableView.endUpdates()
            
        } completion: { _ in
            
            self.faqTableView.beginUpdates()
            self.faqTableView.reloadSections(IndexSet.init(integer: indexPath?.section ?? 0), with: .fade)
            self.faqTableView.endUpdates()
                     
        }
        
        
        
        /*
         let indexPath = self.faqTableView.indexPath(for: cell)
         
        if indexPath?.row == 0 {
            let model = self.faqMessage?.faqdata?[self.selectedPlanIndex].faq?[indexPath?.section ?? 0]
            //let model = arrFaq[indexPath?.section ?? 0]
            
            if model?.isCollapsable == true {
                model?.isCollapsable = false
                let section = IndexSet.init(integer: indexPath?.section ?? 0)
                self.faqTableView.reloadSections(section, with: .none)
            }
            else {
                model?.isCollapsable = true
                let section = IndexSet.init(integer: indexPath?.section ?? 0)
                self.faqTableView.reloadSections(section, with: .none)
            }
        }
        */
        
    }
    
    @IBAction func extendedWarrantyBtnClicked(_ sender: UIButton) {
        self.btnExtWarranty.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.9647058824, blue: 0.6745098039, alpha: 1)
        self.btnExtWarranty.isSelected = true
        self.btnReplacePlus.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.btnReplacePlus.isSelected = false
        
        self.selectedPlanIndex = 0
        DispatchQueue.main.async {
            self.faqTableView.reloadData()
        }
    }
    
    @IBAction func replacePlusBtnClicked(_ sender: UIButton) {
        self.btnExtWarranty.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.btnExtWarranty.isSelected = false
        self.btnReplacePlus.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.9647058824, blue: 0.6745098039, alpha: 1)
        self.btnReplacePlus.isSelected = true
        
        self.selectedPlanIndex = 1
        DispatchQueue.main.async {
            self.faqTableView.reloadData()
        }
    }

    //MARK: UITableView DataSource & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        //return self.arrFaq.count
        
        return self.faqMessage?.faqData?[self.selectedPlanIndex].faq?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let model = self.faqMessage?.faqData?[self.selectedPlanIndex].faq?[section]
        
        if model?.isCollapsable == true {
            //return 2
            return 2
        }else {
            //return 1
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let FaqQuestionTblCell = tableView.dequeueReusableCell(withIdentifier: "FaqQuestionTblCell", for: indexPath) as! FaqQuestionTblCell
            
            FaqQuestionTblCell.lblNum.text = "\(indexPath.section + 1)"
            
            let modelOrder = self.faqMessage?.faqData?[self.selectedPlanIndex].faq?[indexPath.section]
            //let modelOrder = arrFaq[indexPath.section]
            FaqQuestionTblCell.lblQuestion.text = modelOrder?.question
            FaqQuestionTblCell.btnPlusMinus.tag = indexPath.section
            
            if modelOrder?.isCollapsable ?? false {
                FaqQuestionTblCell.btnPlusMinus.setImage(#imageLiteral(resourceName: "minus"), for: .normal)
            }else {
                FaqQuestionTblCell.btnPlusMinus.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
            }
            
            return FaqQuestionTblCell
        }else {
            let FaqAnswerTblCell = tableView.dequeueReusableCell(withIdentifier: "FaqAnswerTblCell", for: indexPath) as! FaqAnswerTblCell
            
            let modelOrder = self.faqMessage?.faqData?[self.selectedPlanIndex].faq?[indexPath.section]
            //let modelOrder = arrFaq[indexPath.section]
            //FaqAnswerTblCell.lblAnswer.text = modelOrder?.answer
            
            FaqAnswerTblCell.LoadWebView(modelOrder?.answer ?? "")
            
            return FaqAnswerTblCell
        }
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        
        let model = self.faqMessage?.faqData?[self.selectedPlanIndex].faq?[indexPath.section]
        
        if model?.isCollapsable == true {
            return UITableView.automaticDimension
        }else {
            if indexPath.row == 1 {
                return 0
            }else {
                return UITableView.automaticDimension
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectonView DataSource & Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPlan.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let PlanCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanCVCell", for: indexPath)
        PlanCVCell.layer.cornerRadius = 10.0
        
        let iconImgVW : UIImageView = PlanCVCell.viewWithTag(10) as! UIImageView
        let lblPlanName : UILabel = PlanCVCell.viewWithTag(20) as! UILabel
        let baseColorView : UIView = PlanCVCell.viewWithTag(30)!
        let baseView : UIView = PlanCVCell.viewWithTag(40)!
        
        UIView.addShadowOnViewThemeColor(baseView: baseView)
        
        let planData = self.arrPlan[indexPath.item]
        let iconData = planData.icons
        
        if indexPath.item == self.selectedPlanIndex {
            baseColorView.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.9647058824, blue: 0.6745098039, alpha: 1)
            lblPlanName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            baseView.isHidden = true
            
            if let url = URL.init(string: iconData?.active ?? "") {
                iconImgVW.af.setImage(withURL: url)
            }
        }else {
            baseColorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblPlanName.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            baseView.isHidden = false
            
            if let url = URL.init(string: iconData?.deactive ?? "") {
                iconImgVW.af.setImage(withURL: url)
            }
        }
        
        lblPlanName.text = self.arrPlan[indexPath.item].name
        return PlanCVCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPlanIndex = indexPath.item
        
        self.lblPlanName.text = self.arrPlan[self.selectedPlanIndex].name
        
        self.faqTableView.reloadData()
        self.planCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.width/2, height: collectionView.bounds.height)
    }
    
    //MARK:- Web Service Methods
    func showHudLoader() {
        hud.textLabel.text = ""
        hud.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7764705882, blue: 0.7568627451, alpha: 0.5)
        hud.show(in: self.view)
    }
    
    func getFaqData() {
        
        var params = [String : Any]()
        params = [
            "userName" : "instaCover",
            "apiKey" : "instaCover"
        ]
        
        //print("params = \(params)")
        self.showHudLoader()
        
        let webService = AF.request(AppURL.kEnquiryPlanFaq, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let response = try JSON(data: responseData.data ?? Data())
                    
                    if response["status"] == "Success" {
                        
                        let result = FaqList.init(json: response)
                        //print(result)
                        
                        self.faqMessage = result.faqMsg
                        self.arrPlan = result.faqMsg?.faqData ?? []
                        
                        DispatchQueue.main.async {
                            self.faqTableView.reloadData()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.lblPlanName.text = self.arrPlan[self.selectedPlanIndex].name
                                self.planCollectionView.reloadData()
                            }
                        }
                        
                    }else {
                        self.showaAlert(message: response["msg"].stringValue)
                    }
                    
                }catch {
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "JSON Exception"))
                }
                
                break
            case .failure(_):
                print(responseData.error ?? NSError())
                self.showaAlert(message: self.getLocalizatioStringValue(key: "Something went wrong!!"))
                break
            }
      
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension FaqTabVC {
    
    // MARK: - Email Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["instacover@compasia.com"])
            mailVC.setSubject("Feedback")
            mailVC.setMessageBody("Email message", isHTML: false)
            self.present(mailVC, animated: true, completion: nil)
        } else {
            // show failure alert
            self.showAlert(title: "No email account", message: "Please configure email account first.", alertButtonTitles: ["OK"], alertButtonStyles: [.default], vc: self) { Index in
                
            }
            
        }
    }
}

extension UITableViewCell {
    var viewControllerForTableView : UIViewController?{
        return ((self.superview as? UITableView)?.delegate as? UIViewController)
    }
}

extension FaqAnswerTblCell {
    
    //MARK: WKWebView delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    self.webViewHeightConstraint.constant = height as! CGFloat
                })
            }
        })
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
           
            guard let url = navigationAction.request.url else {
                print("Link is not a url")
                decisionHandler(.allow)
                return
            }
            
            if url.absoluteString.hasPrefix("file:") {
                print("Open link locally")
                decisionHandler(.allow)
            } else if let host = url.host, !host.hasPrefix("www.google.com"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Redirected to browser.")
                decisionHandler(.cancel)
            } else if url.absoluteString.hasPrefix("mailto:") {
                print("Send email locally")
                
                if let viewController = self.viewControllerForTableView as? FaqTabVC {
                    viewController.sendEmail()
                }
                
                //sendEmail()
                decisionHandler(.allow)
            } else {
                print("Open link locally")
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
    
    /*
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
               let host = url.host, !host.hasPrefix("www.google.com"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
    */
    
    //MARK: Custom Methods
    func LoadWebView(_ strHtml : String) {
        
        self.webView = self.addWKWebView(viewForWeb: self.baseViewForWeb)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        
        
        let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
        
        let htmlString = """
            <style>
            @font-face
            {
                font-family: 'OpenSans';
                font-weight: normal;
                src: url(OpenSans-Regular.ttf);
            }
            @font-face
            {
                font-family: 'OpenSans';
                font-weight: bold;
                src: url(OpenSans-Bold.ttf);
            }
            @font-face
            {
                font-family: 'OpenSans';
                font-weight: medium;
                src: url(OpenSans-SemiBold.ttf);
            }
            </style>
                        <span style="font-family: 'OpenSans'; font-weight: normal; font-size: 15; color: gray">\(headerString + strHtml)</span>
            """
        
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
    
    func addWKWebView(viewForWeb:UIView) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.dataDetectorTypes = .all
        let webView = WKWebView(frame: viewForWeb.frame, configuration: webConfiguration)
        webView.frame.origin = CGPoint.init(x: 0, y: 0)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.frame.size = viewForWeb.frame.size
        webView.scrollView.isScrollEnabled = false
        viewForWeb.addSubview(webView)
        return webView
    }
    
}

class FaqModel {
    
    var strQuestion: String?
    var strAnswer: String?
    var isCollapsable = false
    
    init(FaqListDict: [String: Any]) {
        self.strQuestion = FaqListDict["que"] as? String
        self.strAnswer = FaqListDict["ans"] as? String
        self.isCollapsable = false
    }

    //var arrFaq = [FaqModel]()
    var arrDict = [["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"]]
    
    /*
    for item in self.arrDict {
        let memberDict = FaqModel.init(FaqListDict: item)
        self.arrFaq.append(memberDict)
    }
    
    DispatchQueue.main.async {
        self.faqTableView.reloadData()
    }
    */
    
}
