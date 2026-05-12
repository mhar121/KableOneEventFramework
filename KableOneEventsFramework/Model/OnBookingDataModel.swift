//
//  OnBookingDataModel.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 31/12/2025.
//

import Foundation

class OnBookingDataModel: Codable {
      let couponCode:String?
      let currency: String?
      let sessionId: String?
      let userId: String?
      let order: Order?
}

struct Order: Codable {
    let eventDate: String?
    let eventId: String?
    let eventTime: String?
    let eventTitle: String?
    let isPaid: Bool?

    let screenId: String?
    let screenName: String?

    let slotId: Int?
    let venueId: String?
    let venueName: String?
    let venueType: String?

    let sessionStartAt: String?
    let sessionExpiresAt: String?

    let seatDetails: [SeatDetail]?

    let userId: String?
}

struct SeatDetail: Codable {
    let price: Int?
    let seatId: String?
    let seatNumber: Int?
    let seatRow: String?

    let sectionId: Int?
    let sectionName: String?

    let ticketHolderName: String?
    let ticketHolderEmail: String?
    let ticketHolderPhoneNumber: String?
}
