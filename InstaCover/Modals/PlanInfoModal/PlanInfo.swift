//
//  PlanInfo.swift
//
//  Created by Sameer Khan on 13/08/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class PlanInfo: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kPlanInfoStatusKey: String = "status"
  private let kPlanInfoTimeStampKey: String = "timeStamp"
  private let kPlanInfoMsgKey: String = "msg"

  // MARK: Properties
  public var status: String?
  public var timeStamp: String?
  public var msg: [Msg]?

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
    status = json[kPlanInfoStatusKey].string
    timeStamp = json[kPlanInfoTimeStampKey].string
    if let items = json[kPlanInfoMsgKey].array { msg = items.map { Msg(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kPlanInfoStatusKey] = value }
    if let value = timeStamp { dictionary[kPlanInfoTimeStampKey] = value }
    if let value = msg { dictionary[kPlanInfoMsgKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.status = aDecoder.decodeObject(forKey: kPlanInfoStatusKey) as? String
    self.timeStamp = aDecoder.decodeObject(forKey: kPlanInfoTimeStampKey) as? String
    self.msg = aDecoder.decodeObject(forKey: kPlanInfoMsgKey) as? [Msg]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(status, forKey: kPlanInfoStatusKey)
    aCoder.encode(timeStamp, forKey: kPlanInfoTimeStampKey)
    aCoder.encode(msg, forKey: kPlanInfoMsgKey)
  }

}
