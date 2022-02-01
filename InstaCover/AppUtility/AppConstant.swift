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

//var AppBaseUrl = "https://instacover-uat.getinstacash.in/index.php/"
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
        //static let AppBaseUrl = "https://sbox.getinstacash.in:5000/api/"
    
        static let AppBaseUrl = "https://instacover-uat.getinstacash.in/index.php/"
        //static let AppBaseUrl = "https://coverapi.getinstacash.com.my/index.php/"
    #else
        //static let AppBaseUrl = "https://sbox.getinstacash.in:5000/api/"
        
        //static let AppBaseUrl = "https://instacover-uat.getinstacash.in/index.php/"
        static let AppBaseUrl = "https://coverapi.getinstacash.com.my/index.php/"
    #endif
    
    
    //static let kLogin = BaseURL + "login"
    static let kCustomerSignup = AppBaseUrl + "Customer/customerSignup"
    static let kCustomerLogin = AppBaseUrl + "Customer/customerLogin"
    static let kForgotPassword = AppBaseUrl + "Customer/customerForgotPassword"
    static let kGetCurrentDevice = AppBaseUrl + "getCurrentDevice"
    static let kGetAllProduct = AppBaseUrl + "getAllProduct"
    static let kGetAllPlans = AppBaseUrl + "getAllPlans"
    static let kEnquiryPlanFaq = AppBaseUrl + "Enquiry/planFaq"
    static let kChangePassword = AppBaseUrl + "Customer/changePassword"
    static let kEnquiryContactUs = AppBaseUrl + "Enquiry/contactUs"
    static let kGetEstimate = AppBaseUrl + "getEstimate"
    static let kGetQuote = AppBaseUrl + "getQuote"
    static let kgetiPayTransaction = AppBaseUrl + "getiPayTransaction"
    static let kStoreResult = AppBaseUrl + "storeResult"
    static let kGetQuestions = AppBaseUrl + "getQuestions"
    static let kSaveCustomerQuote = AppBaseUrl + "Customer/saveCustomerQuote"
    static let kGetQuoteData = AppBaseUrl + "Quote/getQuoteData"
    static let kSendVideoLink = AppBaseUrl + "sendVideoLink"
    static let kUploadVideoCheck = AppBaseUrl + "uploadVideoCheck"
    static let kSetiPayTransaction = AppBaseUrl + "setiPayTransaction"
    static let kApplyPromo = AppBaseUrl + "Order/applyPromo"
    static let kRemovePromo = AppBaseUrl + "Order/removePromo"
    
    static let kSaveMobile = AppBaseUrl + "saveMobile"
    static let kGetCustomerType = AppBaseUrl + "getCustomerType"
    static let kgetPaymentFrequency = AppBaseUrl + "getPaymentFrequency"
    static let kSaveCustomerInformation = AppBaseUrl + "saveCustomerInformation"
    static let kGetPaymentMode = AppBaseUrl + "getPaymentMode"
    static let kPaymentInitiate = AppBaseUrl + "paymentInitiate"
    static let kCheckPaymentStatus = AppBaseUrl + "checkPaymentStatus"
    
}

