//
//  HomeEventModel.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 16/12/2025.
//

import Foundation

class EventsData:Codable{
  let banners: [Banner]
  let eventTypes: [EventType]
  var eventDetails: [EventDetail]?
  let venues: [Venue]
  let kableOneMovies: [KableOneMovie]?
}

struct Banner: Codable {
  let id: Int
  let title:String
  let imageUrl:String
  let btnText: String
  let showButton: Bool?
  let btnUrl:String?
}

struct EventType: Codable {
    let id: Int
    let eventTypeName: String
}

struct EventDetail: Codable {
    let eventId: String
    let eventTypeId: Int
    let eventTypeName: String
    let eventTitle: String
    let eventDuration: String
    let eventTimeDetails: [EventTimeDetail]

    let isPaid: Bool
    let venueId: String
    let venueName: String
    let venueType: String?
    let venueAddress: String?
    let pinCode: String?

    let imageUrl: String
    let thumbnail: String
    let totalScreens: Int
    let pricing: String
    let description: String?
    let language: String?
    let entryAllowedFor: String?

    let isPetFriendly: Bool
    let needToTakeTicketInfo: Bool

    let name: Bool
    let email: Bool
    let phoneNumber: Bool
    let isCurrentlyBookMarked: Bool
}

struct EventTimeDetail: Codable {
    let slotId: Int
    let eventDate: String
    let eventTime: String
    let eventStatus: String?
    let screens: [Screen]?
}
struct Screen: Codable {
    let screenName: String
    let screenId: String
    let totalSeats: Int
    let totalSections: Int
}

struct Venue: Codable {
    let venueId: String
    let venueName: String
    let venueType: String
    let totalEvents: Int
}

public struct KableOneMovie: Codable {
  public  let id:Int
  public let mediaId: Int
  public  let type : Int
  public let title: String
  public  let imageUrl: String
  public let isWebSeries: Bool
  public let webSeriesId: Int?

}



struct BookMarkEvent: Codable {
  let isSuccess: Bool
  let isCurrentlyBookMarked: Bool

}
