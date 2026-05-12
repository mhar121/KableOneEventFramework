//
//  DateFormatter.swift
//  Kableone Sales Person
//
//  Created by Muhammad Haris on 10/12/2024.
//

import Foundation
extension DateFormatter{
    static let UserDate: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter

    }()
    static let punchTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter

    }()
    static let appProgressTime: DateFormatter = {
      let formatter = DateFormatter()
       
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
      formatter.locale = Locale(identifier: "en_US_POSIX")
      return formatter
    }()

    static var iso8601WithMilliseconds: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
           return formatter
       }
    static var iso8601WithoutMilliseconds: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")

           return formatter
       }

       /// Returns a shared `DateFormatter` for the "yyyy-MM-dd" format.
       static var simpleDate: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"

           return formatter
       }
    
}
