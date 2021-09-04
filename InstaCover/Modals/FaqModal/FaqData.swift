//
//  Data.swift
//
//  Created by Sameer Khan on 25/08/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Data: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kDataNameKey: String = "name"
  private let kDataFaqKey: String = "faq"

  // MARK: Properties
  public var name: String?
  public var faq: [Faq]?

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
    name = json[kDataNameKey].string
    if let items = json[kDataFaqKey].array { faq = items.map { Faq(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[kDataNameKey] = value }
    if let value = faq { dictionary[kDataFaqKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: kDataNameKey) as? String
    self.faq = aDecoder.decodeObject(forKey: kDataFaqKey) as? [Faq]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: kDataNameKey)
    aCoder.encode(faq, forKey: kDataFaqKey)
  }

}
