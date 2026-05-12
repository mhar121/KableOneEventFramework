//
//  ServerResponse.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 15/12/2025.
//

import Foundation
class ServerResponse<T:Codable>: Codable
{
    let isSuccess: Bool
    let message: String?
    let statusCode: Int
    let data: T?
    let dataList: T?
}
