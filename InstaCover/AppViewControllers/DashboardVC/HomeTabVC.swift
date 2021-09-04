//
//  HomeTabVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit
import DropDown

class HomeTabVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var aboutCollectionView: UICollectionView!
    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var deviceModelView: UIView!
    @IBOutlet weak var deviceTenureView: UIView!
    
    @IBOutlet weak var btnExtWarrantyBaseView: UIView!
    @IBOutlet weak var btnReplacePlusBaseView: UIView!
    @IBOutlet weak var btnExtWarrantyBase: UIButton!
    @IBOutlet weak var btnReplacePlusBase: UIButton!
    @IBOutlet weak var btnExtWarranty: UIButton!
    @IBOutlet weak var btnReplacePlus: UIButton!
    
    var arrAboutImage = [#imageLiteral(resourceName: "openForAll"),#imageLiteral(resourceName: "fastApplication"),#imageLiteral(resourceName: "supportTeam"),#imageLiteral(resourceName: "flexibility")]
    var arrAboutTitle = ["OPEN FOR ALL","FAST APPLICATION","SUPPORT TEAM","FLEXIBILITY"]
    var arrAboutSubTitle = ["No restriction on customer profiles","No supporting documents required","Dedicated customer service officers","Wide selection of models accepted"]
    
    var arrDropDevice = [String]()
    var arrDropTenure = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.arrDropDevice = ["iPhone 6","iPhone 7","iPhone X","iPhone XR","iPhone 11","iPhone 12 Pro"]
        self.arrDropTenure = ["Extended","Replace Plus"]

        self.setUIElements()
    }
    
    //MARK: Custom Method
    func setUIElements() {
        self.btnExtWarranty.isSelected = true
        
        self.setStatusBarGradientColor()
        self.registerTableViewCells()
        
        UIView.addShadowOnView(baseView: self.deviceView)
        
        UIView.addShadowOnViewThemeColor(baseView: self.deviceModelView)
        UIView.addShadowOnViewThemeColor(baseView: self.deviceTenureView)
        UIView.addShadowOnViewThemeColor(baseView: self.btnExtWarrantyBaseView)
        UIView.addShadowOnViewThemeColor(baseView: self.btnReplacePlusBaseView)
    }
    
    func registerTableViewCells() {
        self.aboutCollectionView.register(UINib.init(nibName: "HomeAboutCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeAboutCVCell")
    }

    //MARK: IBAction
    @IBAction func deviceModelBtnClicked(_ sender: UIButton) {
        
        let existingFileDropDown = DropDown()
        existingFileDropDown.anchorView = sender
        existingFileDropDown.cellHeight = 44
        existingFileDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        let typeOfFileArray = self.arrDropDevice
        existingFileDropDown.dataSource = typeOfFileArray
        
        // Action triggered on selection
     
        existingFileDropDown.selectionAction = { [unowned self] (index, item) in
            sender.setTitle(item, for: .normal)
        }
        existingFileDropDown.show()
        
    }
    
    @IBAction func tenureBtnClicked(_ sender: UIButton) {
        
        let existingFileDropDown = DropDown()
        existingFileDropDown.anchorView = sender
        existingFileDropDown.cellHeight = 44
        existingFileDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        let typeOfFileArray = self.arrDropTenure
        existingFileDropDown.dataSource = typeOfFileArray
        
        // Action triggered on selection
     
        existingFileDropDown.selectionAction = { [unowned self] (index, item) in
            sender.setTitle(item, for: .normal)
        }
        existingFileDropDown.show()
        
    }
    
    @IBAction func extendedWarrantyBtnClicked(_ sender: UIButton) {
        
        self.btnExtWarrantyBase.isHidden = false
        self.btnReplacePlusBase.isHidden = true
        self.btnExtWarrantyBaseView.isHidden = true
        self.btnReplacePlusBaseView.isHidden = false
        
        self.btnExtWarranty.isSelected = true
        self.btnReplacePlus.isSelected = false
    }
    
    @IBAction func replacePlusBtnClicked(_ sender: UIButton) {
        
        self.btnExtWarrantyBase.isHidden = true
        self.btnReplacePlusBase.isHidden = false
        self.btnExtWarrantyBaseView.isHidden = false
        self.btnReplacePlusBaseView.isHidden = true
        
        self.btnExtWarranty.isSelected = false
        self.btnReplacePlus.isSelected = true
    }
    
    @IBAction func readMoreBtnClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func proceedPaymentBtnClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func leftArrowBtnClicked(_ sender: UIButton) {
        let collectionBounds = self.aboutCollectionView.bounds
        let contentOffset = CGFloat(floor(self.aboutCollectionView.contentOffset.x - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    @IBAction func rightArrowBtnClicked(_ sender: UIButton) {
        let collectionBounds = self.aboutCollectionView.bounds
        let contentOffset = CGFloat(floor(self.aboutCollectionView.contentOffset.x + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    //MARK: UITableView DataSource & Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let HomeAboutCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeAboutCVCell", for: indexPath) as! HomeAboutCVCell
        HomeAboutCVCell.layer.cornerRadius = 10.0
        
        HomeAboutCVCell.aboutIconImgView.image = self.arrAboutImage[indexPath.item]
        HomeAboutCVCell.lblAboutTitle.text = self.arrAboutTitle[indexPath.item]
        HomeAboutCVCell.lblAboutSubTitle.text = self.arrAboutSubTitle[indexPath.item]
        
        return HomeAboutCVCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.height, height: collectionView.bounds.height)
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.aboutCollectionView.contentOffset.y ,width : self.aboutCollectionView.frame.width,height : self.aboutCollectionView.frame.height)
        self.aboutCollectionView.scrollRectToVisible(frame, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
