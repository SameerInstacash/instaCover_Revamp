//
//  Msg.swift
//
//  Created by Sameer Khan on 26/08/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class UserMsg: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMsgNameKey: String = "name"
  private let kMsgEmailKey: String = "email"
  private let kMsgCreatedDateKey: String = "createdDate"
  private let kMsgMobileKey: String = "mobile"
  private let kMsgRoleKey: String = "role"
  private let kMsgModifiedDateKey: String = "modifiedDate "
  private let kMsgIsDeletedKey: String = "isDeleted"
  private let kMsgInternalIdentifierKey: String = "id"
  private let kMsgUniqueTypeKey: String = "uniqueType"
  private let kMsgLastLoginKey: String = "lastLogin "
  private let kMsgAppleIdKey: String = "appleId"
  private let kMsgUniqueIdKey: String = "uniqueId"
  private let kMsgIsMalaysianKey: String = "isMalaysian"
  private let kMsgPasswordKey: String = "password"
  private let kMsgFcmIdKey: String = "fcmId"

  // MARK: Properties
  public var name: String?
  public var email: String?
  public var createdDate: String?
  public var mobile: String?
  public var role: String?
  public var modifiedDate: String?
  public var isDeleted: String?
  public var internalIdentifier: String?
  public var uniqueType: String?
  public var lastLogin: String?
  public var appleId: String?
  public var uniqueId: String?
  public var isMalaysian: String?
  public var password: String?
  public var fcmId: String?

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
    name = json[kMsgNameKey].string
    email = json[kMsgEmailKey].string
    createdDate = json[kMsgCreatedDateKey].string
    mobile = json[kMsgMobileKey].string
    role = json[kMsgRoleKey].string
    modifiedDate = json[kMsgModifiedDateKey].string
    isDeleted = json[kMsgIsDeletedKey].string
    internalIdentifier = json[kMsgInternalIdentifierKey].string
    uniqueType = json[kMsgUniqueTypeKey].string
    lastLogin = json[kMsgLastLoginKey].string
    appleId = json[kMsgAppleIdKey].string
    uniqueId = json[kMsgUniqueIdKey].string
    isMalaysian = json[kMsgIsMalaysianKey].string
    password = json[kMsgPasswordKey].string
    fcmId = json[kMsgFcmIdKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[kMsgNameKey] = value }
    if let value = email { dictionary[kMsgEmailKey] = value }
    if let value = createdDate { dictionary[kMsgCreatedDateKey] = value }
    if let value = mobile { dictionary[kMsgMobileKey] = value }
    if let value = role { dictionary[kMsgRoleKey] = value }
    if let value = modifiedDate { dictionary[kMsgModifiedDateKey] = value }
    if let value = isDeleted { dictionary[kMsgIsDeletedKey] = value }
    if let value = internalIdentifier { dictionary[kMsgInternalIdentifierKey] = value }
    if let value = uniqueType { dictionary[kMsgUniqueTypeKey] = value }
    if let value = lastLogin { dictionary[kMsgLastLoginKey] = value }
    if let value = appleId { dictionary[kMsgAppleIdKey] = value }
    if let value = uniqueId { dictionary[kMsgUniqueIdKey] = value }
    if let value = isMalaysian { dictionary[kMsgIsMalaysianKey] = value }
    if let value = password { dictionary[kMsgPasswordKey] = value }
    if let value = fcmId { dictionary[kMsgFcmIdKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: kMsgNameKey) as? String
    self.email = aDecoder.decodeObject(forKey: kMsgEmailKey) as? String
    self.createdDate = aDecoder.decodeObject(forKey: kMsgCreatedDateKey) as? String
    self.mobile = aDecoder.decodeObject(forKey: kMsgMobileKey) as? String
    self.role = aDecoder.decodeObject(forKey: kMsgRoleKey) as? String
    self.modifiedDate = aDecoder.decodeObject(forKey: kMsgModifiedDateKey) as? String
    self.isDeleted = aDecoder.decodeObject(forKey: kMsgIsDeletedKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kMsgInternalIdentifierKey) as? String
    self.uniqueType = aDecoder.decodeObject(forKey: kMsgUniqueTypeKey) as? String
    self.lastLogin = aDecoder.decodeObject(forKey: kMsgLastLoginKey) as? String
    self.appleId = aDecoder.decodeObject(forKey: kMsgAppleIdKey) as? String
    self.uniqueId = aDecoder.decodeObject(forKey: kMsgUniqueIdKey) as? String
    self.isMalaysian = aDecoder.decodeObject(forKey: kMsgIsMalaysianKey) as? String
    self.password = aDecoder.decodeObject(forKey: kMsgPasswordKey) as? String
    self.fcmId = aDecoder.decodeObject(forKey: kMsgFcmIdKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: kMsgNameKey)
    aCoder.encode(email, forKey: kMsgEmailKey)
    aCoder.encode(createdDate, forKey: kMsgCreatedDateKey)
    aCoder.encode(mobile, forKey: kMsgMobileKey)
    aCoder.encode(role, forKey: kMsgRoleKey)
    aCoder.encode(modifiedDate, forKey: kMsgModifiedDateKey)
    aCoder.encode(isDeleted, forKey: kMsgIsDeletedKey)
    aCoder.encode(internalIdentifier, forKey: kMsgInternalIdentifierKey)
    aCoder.encode(uniqueType, forKey: kMsgUniqueTypeKey)
    aCoder.encode(lastLogin, forKey: kMsgLastLoginKey)
    aCoder.encode(appleId, forKey: kMsgAppleIdKey)
    aCoder.encode(uniqueId, forKey: kMsgUniqueIdKey)
    aCoder.encode(isMalaysian, forKey: kMsgIsMalaysianKey)
    aCoder.encode(password, forKey: kMsgPasswordKey)
    aCoder.encode(fcmId, forKey: kMsgFcmIdKey)
  }

}
