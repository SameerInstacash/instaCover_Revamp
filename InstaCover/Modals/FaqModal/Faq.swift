//
//  Faq.swift
//
//  Created by Sameer Khan on 27/08/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Faq: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kFaqAnswerKey: String = "answer"
  private let kFaqQuestionKey: String = "question"
  private let kDataIsCollapsableKey: String = "isCollapsable"

  // MARK: Properties
  public var answer: String?
  public var question: String?
  public var isCollapsable: Bool? = false

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
    answer = json[kFaqAnswerKey].string
    question = json[kFaqQuestionKey].string
    isCollapsable = json[kDataIsCollapsableKey].bool
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = answer { dictionary[kFaqAnswerKey] = value }
    if let value = question { dictionary[kFaqQuestionKey] = value }
    if let value = isCollapsable { dictionary[kDataIsCollapsableKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.answer = aDecoder.decodeObject(forKey: kFaqAnswerKey) as? String
    self.question = aDecoder.decodeObject(forKey: kFaqQuestionKey) as? String
    self.isCollapsable = aDecoder.decodeObject(forKey: kDataIsCollapsableKey) as? Bool
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(answer, forKey: kFaqAnswerKey)
    aCoder.encode(question, forKey: kFaqQuestionKey)
    aCoder.encode(isCollapsable, forKey: kDataIsCollapsableKey)
  }

}
