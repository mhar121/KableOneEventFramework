//
//  PaymentModel.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 01/01/2026.
//

import Foundation

class OrderModel:Codable{
    let orderId :String
    let currency:String
    let amount:Int?
    let relationId:String
    let key:String
}
