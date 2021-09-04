//
//  Terms.swift
//
//  Created by Sameer Khan on 13/08/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Terms: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kTermsNameKey: String = "name"
  private let kTermsIpCodeKey: String = "ipCode"
  private let kTermsInternalIdentifierKey: String = "id"
  private let kTermsFaqKey: String = "faq"
  private let kTermsTncKey: String = "tnc"
  private let kTermsDescriptionValueKey: String = "description"
  private let kTermsTermKey: String = "term"

  // MARK: Properties
  public var name: String?
  public var ipCode: String?
  public var internalIdentifier: String?
  public var faq: String?
  public var tnc: String?
  public var descriptionValue: String?
  public var term: String?

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
    name = json[kTermsNameKey].string
    ipCode = json[kTermsIpCodeKey].string
    internalIdentifier = json[kTermsInternalIdentifierKey].string
    faq = json[kTermsFaqKey].string
    tnc = json[kTermsTncKey].string
    descriptionValue = json[kTermsDescriptionValueKey].string
    term = json[kTermsTermKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[kTermsNameKey] = value }
    if let value = ipCode { dictionary[kTermsIpCodeKey] = value }
    if let value = internalIdentifier { dictionary[kTermsInternalIdentifierKey] = value }
    if let value = faq { dictionary[kTermsFaqKey] = value }
    if let value = tnc { dictionary[kTermsTncKey] = value }
    if let value = descriptionValue { dictionary[kTermsDescriptionValueKey] = value }
    if let value = term { dictionary[kTermsTermKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: kTermsNameKey) as? String
    self.ipCode = aDecoder.decodeObject(forKey: kTermsIpCodeKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kTermsInternalIdentifierKey) as? String
    self.faq = aDecoder.decodeObject(forKey: kTermsFaqKey) as? String
    self.tnc = aDecoder.decodeObject(forKey: kTermsTncKey) as? String
    self.descriptionValue = aDecoder.decodeObject(forKey: kTermsDescriptionValueKey) as? String
    self.term = aDecoder.decodeObject(forKey: kTermsTermKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: kTermsNameKey)
    aCoder.encode(ipCode, forKey: kTermsIpCodeKey)
    aCoder.encode(internalIdentifier, forKey: kTermsInternalIdentifierKey)
    aCoder.encode(faq, forKey: kTermsFaqKey)
    aCoder.encode(tnc, forKey: kTermsTncKey)
    aCoder.encode(descriptionValue, forKey: kTermsDescriptionValueKey)
    aCoder.encode(term, forKey: kTermsTermKey)
  }

}
