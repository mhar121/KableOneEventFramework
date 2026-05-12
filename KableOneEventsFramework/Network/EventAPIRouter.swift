//
//  APIRouter.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 15/12/2025.
//

import Foundation
internal import Alamofire


enum EventAPIRouter: URLRequestConvertible {
  case getStates(countryId: String)
  case getCities(stateId: String)
  case getHomeData(userId: String, countryId: Int,stateId:Int,cityId:Int)
  case getMoreEvents(userId: String, countryId: Int,stateId:Int,cityId:Int,eventTypeId:Int,pageNo:Int,pageSize:Int)
  case getEventDetails(userId: String, eventId:String)
  case createOrder(userId: String, sessionId: String,couponCode:String)
  case verifyPayment(userId: String, razorPaymentId: String,razorOrderId:String,relationId:String,sessionId:String,signature:String)
  case bookmarkEvent(userId: String,eventId:String, isCurrentlyBookMarked:Bool)
  case bookFreeSeats(userId: String, sessionId: String)



  // MARK: - HTTP Method
  private var method: HTTPMethod {
      switch self {
      case .getCities,.getStates:
          return .get
      default:
          return .post
      }
  }

  // MARK: - Path
  private var path: String {
    switch self {
    case .getStates(let countryId):
      return "Home/GetStatesListForCountry?countryId=\(countryId)"
    case .getCities(let stateId):
      return "Home/GetCitiesListForState?stateId=\(stateId)"
    case .getHomeData:
      return "Home/GetHomeData"
    case .getEventDetails:
      return "Events/GetEventDetailsByEventId"
    case .getMoreEvents:
      return "Home/LoadMoreEvents"
    case .createOrder:
      return "Payment/CreateOrder"
    case .verifyPayment:
      return "Payment/VerifyOrder"
    case .bookmarkEvent:
      return "Events/AddEventToBookmark"
    case .bookFreeSeats:
      return "Booking/BookSeats"
    }
  }

  // MARK: - Parameters
  private var parameters: Any? {
    switch self {
    case .getStates:
      return nil
    case .getCities:
      return nil
    case .getHomeData(let userId, let countryId, let stateId, let cityId):
      return ["userId": userId, "countryId": countryId,"stateId":stateId,"cityId":cityId]

    case .getEventDetails(let userId, let eventId):
      return ["userId": userId,"eventId":eventId]
    case .getMoreEvents(let userId,let countryId,let stateId, let cityId,let eventTypeId,let pageNo, let pageSize):
      return ["userId": userId, "countryId": countryId,"stateId":stateId,"cityId":cityId,"eventTypeId":eventTypeId,"pageNo":pageNo,"pageSize":pageSize]
    case .createOrder(let userId, let sessionId, let couponCode):
      return ["userId": userId, "sessionId": sessionId, "couponCode": couponCode]
    case .verifyPayment(let userId, let razorPaymentId, let razorOrderId,let relationId, let sessionId, let signature):
      return ["userId":userId,"razorpay_payment_id":razorPaymentId,"razorpay_order_id":razorOrderId,"relationId":relationId,"sessionId":sessionId,"razorpay_signature":signature]
    case .bookmarkEvent(let userId, let eventId, let isCurrentlyBookMarked):
      return [ "userId": userId, "eventId":eventId,"isCurrentlyBookMarked": isCurrentlyBookMarked]
    case .bookFreeSeats(let userId, let sessionId):
      return ["userId": userId, "sessionId": sessionId]
    }
  }

  private var baseUrl: String {
      return "\(Constants.baseUrl)/api/"
  }

  // MARK: - Headers
  private var headers: [String: String]? {
      switch self {

      default:
          return [
                  "Content-Type":"application/json",
                  "Authorization":"Bearer \(Constants.token)",
                  "ApiKey" : "KableONE@74#"
          ]
      }
  }
  // MARK: - URLRequestConvertible
  func asURLRequest() throws -> URLRequest {
      var baseURL = self.baseUrl
      baseURL.append(path)
      let url = try baseURL.asURL()
      var urlRequest = URLRequest(url: url)
      // HTTP Method
      urlRequest.httpMethod = method.rawValue
      if let headers = headers{
          for (key,val) in headers{
              urlRequest.setValue(val, forHTTPHeaderField: key)
          }
      }
      // Parameters
      if let parameters = parameters {
          urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
      }
    print(parameters as Any)
      return urlRequest
  }

}
