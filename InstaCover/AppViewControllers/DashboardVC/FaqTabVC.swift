//
//  FaqTabVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit

class FaqModel {
    
    var strQuestion: String?
    var strAnswer: String?
    var isCollapsable = false
    
    init(FaqListDict: [String: Any]) {
        self.strQuestion = FaqListDict["que"] as? String
        self.strAnswer = FaqListDict["ans"] as? String
        self.isCollapsable = false
    }

}

class FaqTabVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var faqTableView: UITableView!
    @IBOutlet weak var heightOfFaqTableView: NSLayoutConstraint!
    @IBOutlet weak var questionTextField: UITextField!
    
    @IBOutlet weak var btnExtWarranty: UIButton!
    @IBOutlet weak var btnReplacePlus: UIButton!
    
    var arrFaq = [FaqModel]()
    
    var arrDict = [["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"],["que" : "What is InstaCover Extended Warranty Program?","ans" : "InstaCover Extended Warranty program is an after-sales service program offered to InstaCover customers,which covers the customer's device's warranty for an extended period (subject to the applicable InstaCover Terms & Conditions). For information, please refer to the program"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
        
        for item in self.arrDict {
            let memberDict = FaqModel.init(FaqListDict: item)
            self.arrFaq.append(memberDict)
        }
        
        DispatchQueue.main.async {
            self.faqTableView.reloadData()
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
                
        if indexPath?.row == 0 {
            let model = arrFaq[indexPath?.section ?? 0]
            
            if model.isCollapsable == true {
                model.isCollapsable = false
                let section = IndexSet.init(integer: indexPath?.section ?? 0)
                self.faqTableView.reloadSections(section, with: .fade)
            }
            else {
                model.isCollapsable = true
                let section = IndexSet.init(integer: indexPath?.section ?? 0)
                self.faqTableView.reloadSections(section, with: .fade)
            }
        }
        
    }
    
    @IBAction func extendedWarrantyBtnClicked(_ sender: UIButton) {
        self.btnExtWarranty.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.9647058824, blue: 0.6745098039, alpha: 1)
        self.btnExtWarranty.isSelected = true
        self.btnReplacePlus.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.btnReplacePlus.isSelected = false
    }
    
    @IBAction func replacePlusBtnClicked(_ sender: UIButton) {
        self.btnExtWarranty.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.btnExtWarranty.isSelected = false
        self.btnReplacePlus.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.9647058824, blue: 0.6745098039, alpha: 1)
        self.btnReplacePlus.isSelected = true
    }

    //MARK: UITableView DataSource & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrFaq.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let model = arrFaq[section]
        if model.isCollapsable == true {
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let FaqQuestionTblCell = tableView.dequeueReusableCell(withIdentifier: "FaqQuestionTblCell", for: indexPath) as! FaqQuestionTblCell
            
            let modelOrder = arrFaq[indexPath.section]
            FaqQuestionTblCell.lblQuestion.text = modelOrder.strQuestion
            
            
            return FaqQuestionTblCell
        }else {
            let FaqAnswerTblCell = tableView.dequeueReusableCell(withIdentifier: "FaqAnswerTblCell", for: indexPath) as! FaqAnswerTblCell
            
            let modelOrder = arrFaq[indexPath.section]
            FaqAnswerTblCell.lblAnswer.text = modelOrder.strAnswer
            
            return FaqAnswerTblCell
        }
     
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
