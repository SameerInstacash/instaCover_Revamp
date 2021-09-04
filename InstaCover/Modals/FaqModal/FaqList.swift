//
//  FaqList.swift
//
//  Created by Sameer Khan on 27/08/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class FaqList: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kFaqListStatusKey: String = "status"
  private let kFaqListTimeStampKey: String = "timeStamp"
  private let kFaqListMsgKey: String = "msg"

  // MARK: Properties
  public var status: String?
  public var timeStamp: String?
  public var faqMsg: FaqMsg?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    status = json[kFaqListStatusKey].string
    timeStamp = json[kFaqListTimeStampKey].string
    faqMsg = FaqMsg(json: json[kFaqListMsgKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kFaqListStatusKey] = value }
    if let value = timeStamp { dictionary[kFaqListTimeStampKey] = value }
    if let value = faqMsg { dictionary[kFaqListMsgKey] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.status = aDecoder.decodeObject(forKey: kFaqListStatusKey) as? String
    self.timeStamp = aDecoder.decodeObject(forKey: kFaqListTimeStampKey) as? String
    self.faqMsg = aDecoder.decodeObject(forKey: kFaqListMsgKey) as? FaqMsg
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(status, forKey: kFaqListStatusKey)
    aCoder.encode(timeStamp, forKey: kFaqListTimeStampKey)
    aCoder.encode(faqMsg, forKey: kFaqListMsgKey)
  }

}
