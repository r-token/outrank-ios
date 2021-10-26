//
//  AppGroup.swift
//  Outrank
//
//  Created by Ryan Token on 10/14/21.
//

import Foundation

public enum AppGroup: String {
  case groupId = "group.com.ryantoken.teamrankings"

  public var containerURL: URL {
    switch self {
    case .groupId:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
