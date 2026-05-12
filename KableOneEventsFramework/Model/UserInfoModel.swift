//
//  UserInfoModel.swift
//  KableOneEventsFramework
//
//  Created by Muhammad Haris on 09/01/2026.
//

import Foundation

public class EventUserInfoModel:Codable{
      public let id: String
      public let objectID: String
      public let firstName: String
      public let lastName: String?
      public let email: String?
      public let mobile: String?

  public init(id: String, objectID: String, firstName: String, lastName: String?, email: String?, mobile: String?) {
    self.id = id
    self.objectID = objectID
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.mobile = mobile
  }

}


