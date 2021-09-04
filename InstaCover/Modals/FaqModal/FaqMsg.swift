//
//  Msg.swift
//
//  Created by Sameer Khan on 27/08/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class FaqMsg: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMsgDataKey: String = "data"

  // MARK: Properties
  public var faqData: [FaqData]?

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
    if let items = json[kMsgDataKey].array { faqData = items.map { FaqData(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = faqData { dictionary[kMsgDataKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.faqData = aDecoder.decodeObject(forKey: kMsgDataKey) as? [FaqData]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(faqData, forKey: kMsgDataKey)
  }

}
