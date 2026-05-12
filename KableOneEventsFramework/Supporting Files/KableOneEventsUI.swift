//
//  KableOneEventsUI.swift
//  KableOneEventsFramework
//
//  Created by Muhammad Haris on 06/01/2026.
//

import UIKit

public enum KableOneEventsUI {

    public static func homeViewController() -> HomeVC {
        let bundle = Bundle(for: HomeVC.self) // points to framework bundle
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)

        guard let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else {
            fatalError("HomeVC not found in Main.storyboard")
        }
        return vc
    }

  public static weak var appContextProvider: AppContextProvider?

  public static func authToken() -> String {
      return appContextProvider?.getAuthToken() ?? ""
  }

  public static func currentUser() -> EventUserInfoModel? {
      return appContextProvider?.getEventUser()
  }

  public static var openLogin: (() -> Void)?
  public static var openVideoDetail: ((KableOneMovie) -> Void)?

}
public protocol AppContextProvider: AnyObject {
    func getAuthToken() -> String
    func getEventUser() -> EventUserInfoModel?
}

