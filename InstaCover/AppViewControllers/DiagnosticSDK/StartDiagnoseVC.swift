//
//  StartDiagnoseVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 25/08/21.
//

import UIKit

class StartDiagnoseVC: UIViewController {
    
    var startDiagnosis: (() -> Void)?
    
    @IBOutlet weak var testImgView: UIImageView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.setUIElementsProperties()
        }
        
    }
    
    // MARK: Custom Methods
    
    func setUIElementsProperties() {
        
        self.subHeadingLbl.setLineHeight(lineHeight: 3.0)
        self.subHeadingLbl.textAlignment = .center
        
        self.setStatusBarGradientColor()
        
        self.startBtn.backgroundColor = AppThemeColor
        self.startBtn.layer.cornerRadius = AppBtnCornerRadius
        self.startBtn.setTitleColor(AppBtnTitleColor, for: .normal)
        let fontSize = self.startBtn.titleLabel?.font.pointSize
        self.startBtn.titleLabel?.font = UIFont.init(name: AppFontBold, size: fontSize ?? 18.0)
        
    
        // MultiLingual
        self.startBtn.setTitle(self.getLocalizatioStringValue(key: "I'm ready"), for: .normal)
        self.headingLbl.text = self.getLocalizatioStringValue(key: "Diagnostic")
        self.headingLbl.font = UIFont.init(name: AppFontBold, size: self.headingLbl.font.pointSize)
        self.subHeadingLbl.text = self.getLocalizatioStringValue(key: "Hi! You're about to diagnose your phone to help us give you an exact quote.")
        self.subHeadingLbl.font = UIFont.init(name: AppFontSemiBold, size: self.subHeadingLbl.font.pointSize)
      
    }

    // MARK:- IBActions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func iamReadyButtonPressed(_ sender: UIButton) {
        //guard let didFinishDiagnosis = self.startDiagnosis else { return }
        guard let didFinishDiagnosis = performDiagnostics else { return }
        didFinishDiagnosis()
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
