//
//  AllProducts.swift
//
//  Created by Sameer Khan on 14/08/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class AllProducts: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kAllProductsStatusKey: String = "status"
  private let kAllProductsTimeStampKey: String = "timeStamp"
  private let kAllProductsMsgKey: String = "msg"

  // MARK: Properties
  public var status: String?
  public var timeStamp: String?
  public var productMsg: [Products]?

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
    status = json[kAllProductsStatusKey].string
    timeStamp = json[kAllProductsTimeStampKey].string
    if let items = json[kAllProductsMsgKey].array { productMsg = items.map { Products(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kAllProductsStatusKey] = value }
    if let value = timeStamp { dictionary[kAllProductsTimeStampKey] = value }
    if let value = productMsg { dictionary[kAllProductsMsgKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.status = aDecoder.decodeObject(forKey: kAllProductsStatusKey) as? String
    self.timeStamp = aDecoder.decodeObject(forKey: kAllProductsTimeStampKey) as? String
    self.productMsg = aDecoder.decodeObject(forKey: kAllProductsMsgKey) as? [Products]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(status, forKey: kAllProductsStatusKey)
    aCoder.encode(timeStamp, forKey: kAllProductsTimeStampKey)
    aCoder.encode(productMsg, forKey: kAllProductsMsgKey)
  }

}
