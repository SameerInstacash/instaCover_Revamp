//
//  Msg.swift
//
//  Created by Sameer Khan on 14/08/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Products: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMsgInternalIdentifierKey: String = "id"
  private let kMsgBrandnameKey: String = "brandname"
  private let kMsgProductNameKey: String = "productName"

  // MARK: Properties
  public var internalIdentifier: String?
  public var brandname: String?
  public var productName: String?

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
    internalIdentifier = json[kMsgInternalIdentifierKey].string
    brandname = json[kMsgBrandnameKey].string
    productName = json[kMsgProductNameKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kMsgInternalIdentifierKey] = value }
    if let value = brandname { dictionary[kMsgBrandnameKey] = value }
    if let value = productName { dictionary[kMsgProductNameKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.internalIdentifier = aDecoder.decodeObject(forKey: kMsgInternalIdentifierKey) as? String
    self.brandname = aDecoder.decodeObject(forKey: kMsgBrandnameKey) as? String
    self.productName = aDecoder.decodeObject(forKey: kMsgProductNameKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(internalIdentifier, forKey: kMsgInternalIdentifierKey)
    aCoder.encode(brandname, forKey: kMsgBrandnameKey)
    aCoder.encode(productName, forKey: kMsgProductNameKey)
  }

}
