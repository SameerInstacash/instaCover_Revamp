//
//  UserData.swift
//
//  Created by Sameer Khan on 26/08/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class UserData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kUserDataMsgKey: String = "msg"
  private let kUserDataStatusKey: String = "status"
  private let kUserDataTimeStampKey: String = "timeStamp "

  // MARK: Properties
  public var msg: Msg?
  public var status: String?
  public var timeStamp: String?

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
    msg = Msg(json: json[kUserDataMsgKey])
    status = json[kUserDataStatusKey].string
    timeStamp = json[kUserDataTimeStampKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = msg { dictionary[kUserDataMsgKey] = value.dictionaryRepresentation() }
    if let value = status { dictionary[kUserDataStatusKey] = value }
    if let value = timeStamp { dictionary[kUserDataTimeStampKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.msg = aDecoder.decodeObject(forKey: kUserDataMsgKey) as? Msg
    self.status = aDecoder.decodeObject(forKey: kUserDataStatusKey) as? String
    self.timeStamp = aDecoder.decodeObject(forKey: kUserDataTimeStampKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(msg, forKey: kUserDataMsgKey)
    aCoder.encode(status, forKey: kUserDataStatusKey)
    aCoder.encode(timeStamp, forKey: kUserDataTimeStampKey)
  }

}
