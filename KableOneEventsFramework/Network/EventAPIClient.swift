//
//  APIClient.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 15/12/2025.
//

import Foundation
internal import Alamofire

class EventAPIClient {
  static let shared = EventAPIClient()
  private var session: Alamofire.Session = AF
  init(){
    let trustManager = ServerTrustManager(
        evaluators: [
            "testeventapi.kableone.com": DisabledTrustEvaluator(),
            "eventapi.kableone.com": DisabledTrustEvaluator()
        ]
    )


          self.session = Session(serverTrustManager: trustManager)
      }


  @discardableResult
  private static func performRequest<T:Decodable>(route:EventAPIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T,AFError>)->Void) -> DataRequest {
      //completion(Result.failure(Error.))
      return shared.session.request(route)/*.log(.verbose)*/
          .responseDecodable (decoder: decoder){ (response: DataResponse<T,AFError>) in
              if response.response?.statusCode == 401{
                  DispatchQueue.main.async {
                      NotificationCenter.default.post(name: Notification.Name("UserUnauthorized"), object: nil)
                  }
              }
              completion(response.result)

          }
  }
  static func getStates(countryId:String,completion:@escaping (Result<ServerResponse<[StateModel]>,AFError>)->Void){
    performRequest(route: .getStates(countryId: countryId), completion: completion)
  }
  static func getCities(stateId:String,completion:@escaping (Result<ServerResponse<[StateModel]>,AFError>)->Void){
    performRequest(route: .getCities(stateId: stateId), completion: completion)
  }

  static func getHomeData(userId:String,countryId:Int,stateId:Int,cityId:Int,completion:@escaping (Result<ServerResponse<EventsData>,AFError>)->Void){
    performRequest(route: .getHomeData(userId: userId, countryId: countryId, stateId: stateId, cityId: cityId), completion: completion)
  }
  static func getEventDetails(userId:String,eventId:String,completion:@escaping (Result<ServerResponse<EventDetail>,AFError>)->Void){
    performRequest(route: .getEventDetails(userId: userId, eventId: eventId), completion: completion)
  }

  static func getMoreEvents(userId:String,countryId:Int,stateId:Int,cityId:Int,eventTypeId:Int,pageNo:Int,pageSize:Int,completion:@escaping (Result<ServerResponse<[EventDetail]>,AFError>)->Void){
    performRequest(route: .getMoreEvents(userId: userId, countryId: countryId, stateId: stateId, cityId: cityId, eventTypeId: eventTypeId, pageNo: pageNo, pageSize: pageSize), completion: completion)
  }
  static func createOrder(userId:String,sessionId:String,couponCode:String,completion:@escaping (Result<ServerResponse<OrderModel>,AFError>)->Void){
    performRequest(route: .createOrder(userId: userId, sessionId: sessionId, couponCode: couponCode), completion: completion)
  }
  static func verifyPayment(userId:String,sessionId:String,razorPaymentId:String,relationId:String,razorOrderId:String,signature:String ,completion:@escaping (Result<ServerResponse<[EventDetail]>,AFError>)->Void){
    performRequest(route: .verifyPayment(userId: userId, razorPaymentId: razorPaymentId, razorOrderId: razorOrderId, relationId: relationId, sessionId: sessionId, signature: signature), completion: completion)
  }
  static func addBookmarkEvent(userId:String, eventId:String, isCurrentlyBookMarked:Bool,completion:@escaping (Result<ServerResponse<BookMarkEvent>,AFError>)->Void){
    performRequest(route: .bookmarkEvent(userId: userId, eventId: eventId, isCurrentlyBookMarked: isCurrentlyBookMarked), completion: completion)
  }

  static func bookFreeSeats(userId:String,sessionId:String,completion:@escaping (Result<ServerResponse<BookMarkEvent>,AFError>)->Void){
    performRequest(route: .bookFreeSeats(userId: userId, sessionId: sessionId), completion: completion)
  }
}
