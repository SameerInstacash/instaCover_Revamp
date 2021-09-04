//
//  DetailViewModel.swift
//  SDKSampleAppSwift
//
//  Created by Muhammad Syafiq bin Mastor on 07/03/2019.
//  Copyright © 2019 iPay88. All rights reserved.
//

import Foundation

class DetailViewModel {

    var detail : DetailModel = DetailModel()
    var item = TextfieldType.standard

    init() {
        
    }

}

struct DetailModel {
    
    var productDescription : String = "testing"
    var amount : String = "1.00"
    var customerName : String = "User Name"
    var phoneNumber : String = "0171234567"
    var email : String = "sdktester@ipay88.com"
    //var merchantCode : String = "M05133"
    //var merchantKey : String = "Az2QqzFdKz"
    var merchantCode : String = "M28460_S0002"
    var merchantKey : String = "lObOlu9PD3"
    var paymentID : String = "2"
    var currency : String = "MYR"
    var language : String = "UTF-8"
    var remark : String = "Testing SDK"
    var country : String = "MY"
    var backendURL : String = "http://merchant.com/backend.php"
    
    var refNo : String {
        let time = Date.timeIntervalSinceReferenceDate
        return String(describing: time).replacingOccurrences(of: ".", with: "")
    }
    
}

enum TextfieldType : String {
    
    case productDescription = "Product Description"
    case amount = "Amount (RM)"
    case customerName = "Customer Name"
    case phoneNumber = "Phone Number"
    case email = "Email"
    case merchantCode = "Merchant Code"
    case merchantKey = "MerchantKey"
    case paymentID = "PaymentID"
    case currency = "Currency"
    case language = "Language"
    case remark = "Remarks"
    case country = "Country"
    case backendURL = "Backend Post URL"
    case refNo = "RefNo"
    
    var value : String {
        switch self {
        case .refNo:
            let time = Date.timeIntervalSinceReferenceDate
            return String(describing: time).replacingOccurrences(of: ".", with: "")
        case .productDescription:
            return "testing"
        case .amount:
            return "1.00"
        case .customerName:
            return "User Name"
        case .phoneNumber:
            return "0171234567"
        case .email:
            return "sdktester@ipay88.com"
        case .merchantCode:
            return "M05133"
        case .merchantKey:
            return "Az2QqzFdKz"
        case .paymentID:
            return "2"
        case .currency:
            return "MYR"
        case .language:
            return "UTF-8"
        case .remark:
            return "cheap cheap"
        case .country:
            return "MY"
        case .backendURL:
            return "http://merchant.com/backend.php"
        }
    }
    
    static let standard = [refNo, productDescription, amount, customerName, phoneNumber, email,merchantCode, merchantKey, paymentID, currency,language,remark, country, backendURL]
}




