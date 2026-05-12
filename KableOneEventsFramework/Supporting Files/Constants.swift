//
//  Constants.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 15/12/2025.
//

import Foundation
class Constants{

  
  static let baseUrl = "https://testeventapi.kableone.com"
  //static let baseUrl = "https://eventapi.kableone.com"

  //static let userId = "12e252fb-983d-44c5-b843-11f994e32938"  //email
  //static let userId = "3ee5d294-8ec5-4c0e-9fc7-9a7efb25fb3b"   //num
  //static let token  = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJFbWFpbCI6Im1laGFyaGFyaXMwMUBnbWFpbC5jb20iLCJOYW1lIjoiSGFyaXMiLCJNb2JpbGUiOiIzMDA2NDIxMTE4IiwiSWQiOiIyMTMiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJVc2VyIiwic2lkIjoiMjEzIiwiT2JqZWN0SUQiOiIxMmUyNTJmYi05ODNkLTQ0YzUtYjg0My0xMWY5OTRlMzI5MzgiLCJleHAiOjE3OTM1MjQ2NDR9.8WFPWSfcwMTEDMbsWZsEdIx1tlDayUbJgcCIwRAT-SA"   // email
  //static let token  = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJFbWFpbCI6IiIsIk5hbWUiOiJIYXJpIiwiTW9iaWxlIjoiMzAwNjQyMTgzOCIsIklkIjoiNTY3IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiVXNlciIsInNpZCI6IjU2NyIsIk9iamVjdElEIjoiM2VlNWQyOTQtOGVjNS00YzBlLTlmYzctOWE3ZWZiMjVmYjNiIiwiZXhwIjoxNzgyNTg0NjA5fQ.EvVWRq-jdqh_N2j_HfduiRHmoTywv8KcALBtfcunfDA"   //num
  static let userId = KableOneEventsUI.currentUser()?.objectID ?? ""
  static let token = KableOneEventsUI.authToken()

}
