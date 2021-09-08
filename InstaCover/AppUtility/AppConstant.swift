//
//  AppConstant.swift
//  InstaCashApp
//
//  Created by Sameer Khan on 06/07/21.
//

import UIKit
import SwiftyJSON

var performDiagnostics: (() -> Void)?
var arrTestsInSDK = [String]()
var arrHoldTestsInSDK = [String]()

var AppBaseUrl = "https://instacover-uat.getinstacash.in/index.php/"
var AppUserName = "storeIOS"
var AppApiKey = "b99d0f356515682d17cc90265703afc9"

var AppCurrentProductBrand = ""
var AppCurrentProductName = ""
var AppCurrentProductImage = ""

// ***** App Theme Color ***** //
var AppFirstThemeColorHexString : String = "#5AD4E5"
var AppSecondThemeColorHexString : String = "#6BF3EC"

var AppThemeColor : UIColor = UIColor().HexToColor(hexString: "#5AD4E5", alpha: 1.0)
var AppFirstThemeColor : UIColor = UIColor().HexToColor(hexString: "#5AD4E5", alpha: 1.0)
var AppSecondThemeColor : UIColor = UIColor().HexToColor(hexString: "#6BF3EC", alpha: 1.0)

// ***** Font-Family ***** //
var AppFontRegular = "OpenSans-Regular"
var AppFontBold = "OpenSans-Bold"
var AppFontSemiBold = "OpenSans-SemiBold"

// ***** Button Properties ***** //
var AppBtnCornerRadius : CGFloat = 10
var AppBtnTitleColorHexString : String?
var AppBtnTitleColor : UIColor = UIColor().HexToColor(hexString: AppBtnTitleColorHexString ?? "#FFFFFF", alpha: 1.0)

let AppUserDefaults = UserDefaults.standard
var AppResultJSON = JSON()
var AppResultString = ""

var AppOrientationLock = UIInterfaceOrientationMask.all
var AppCurrency = "RM"

// Api Name
struct AppURL {
    
    #if DEBUG
        //static let BaseURL = "https://sbox.getinstacash.in:5000/api/"
    
        static let BaseURL = "https://instacover-uat.getinstacash.in/index.php/"
        //static let BaseURL = "https://coverapi.getinstacash.com.my/index.php/"
    #else
        //static let BaseURL = "https://sbox.getinstacash.in:5000/api/"
        
        //static let BaseURL = "https://instacover-uat.getinstacash.in/index.php/"
        static let BaseURL = "https://coverapi.getinstacash.com.my/index.php/"
    #endif
    
    
    //static let kLogin = BaseURL + "login"
    static let kCustomerSignup = BaseURL + "Customer/customerSignup"
    static let kCustomerLogin = BaseURL + "Customer/customerLogin"
    static let kForgotPassword = BaseURL + "Customer/customerForgotPassword"
    static let kGetCurrentDevice = BaseURL + "getCurrentDevice"
    static let kGetAllProduct = BaseURL + "getAllProduct"
    static let kGetAllPlans = BaseURL + "getAllPlans"
    static let kEnquiryPlanFaq = BaseURL + "Enquiry/planFaq"
    static let kChangePassword = BaseURL + "Customer/changePassword"
    static let kEnquiryContactUs = BaseURL + "Enquiry/contactUs"
    static let kGetEstimate = BaseURL + "getEstimate"
    static let kGetQuote = BaseURL + "getQuote"
    static let kgetiPayTransaction = BaseURL + "getiPayTransaction"
    static let kStoreResult = BaseURL + "storeResult"
    static let kGetQuestions = BaseURL + "getQuestions"
    static let kSaveCustomerQuote = BaseURL + "Customer/saveCustomerQuote"
    static let kGetQuoteData = BaseURL + "Quote/getQuoteData"
    static let kSendVideoLink = BaseURL + "sendVideoLink"
    static let kUploadVideoCheck = BaseURL + "uploadVideoCheck"
    
    
    static let kSaveMobile = BaseURL + "saveMobile"
    static let kGetCustomerType = BaseURL + "getCustomerType"
    static let kgetPaymentFrequency = BaseURL + "getPaymentFrequency"
    static let kSaveCustomerInformation = BaseURL + "saveCustomerInformation"
    static let kGetPaymentMode = BaseURL + "getPaymentMode"
    static let kPaymentInitiate = BaseURL + "paymentInitiate"
    static let kCheckPaymentStatus = BaseURL + "checkPaymentStatus"
    
}

