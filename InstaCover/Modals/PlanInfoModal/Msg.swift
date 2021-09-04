//
//  Msg.swift
//
//  Created by Sameer Khan on 27/08/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Msg: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMsgTermsKey: String = "terms"
  private let kMsgNameKey: String = "name"
  private let kMsgIconsKey: String = "icons"

  // MARK: Properties
  public var terms: [Terms]?
  public var name: String?
  public var icons: Icons?

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
    if let items = json[kMsgTermsKey].array { terms = items.map { Terms(json: $0) } }
    name = json[kMsgNameKey].string
    icons = Icons(json: json[kMsgIconsKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = terms { dictionary[kMsgTermsKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = name { dictionary[kMsgNameKey] = value }
    if let value = icons { dictionary[kMsgIconsKey] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.terms = aDecoder.decodeObject(forKey: kMsgTermsKey) as? [Terms]
    self.name = aDecoder.decodeObject(forKey: kMsgNameKey) as? String
    self.icons = aDecoder.decodeObject(forKey: kMsgIconsKey) as? Icons
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(terms, forKey: kMsgTermsKey)
    aCoder.encode(name, forKey: kMsgNameKey)
    aCoder.encode(icons, forKey: kMsgIconsKey)
  }

}
