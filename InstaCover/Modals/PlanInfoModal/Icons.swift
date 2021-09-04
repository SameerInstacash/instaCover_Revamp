//
//  Icons.swift
//
//  Created by Sameer Khan on 27/08/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Icons: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kIconsDeactiveKey: String = "deactive"
  private let kIconsActiveKey: String = "active"

  // MARK: Properties
  public var deactive: String?
  public var active: String?

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
    deactive = json[kIconsDeactiveKey].string
    active = json[kIconsActiveKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = deactive { dictionary[kIconsDeactiveKey] = value }
    if let value = active { dictionary[kIconsActiveKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.deactive = aDecoder.decodeObject(forKey: kIconsDeactiveKey) as? String
    self.active = aDecoder.decodeObject(forKey: kIconsActiveKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(deactive, forKey: kIconsDeactiveKey)
    aCoder.encode(active, forKey: kIconsActiveKey)
  }

}
