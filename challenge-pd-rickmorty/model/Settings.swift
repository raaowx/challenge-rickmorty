//
//  Settings.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 13/8/21.
//

import Foundation

struct Settings {
  static var shared = Settings()
  private let defaults: UserDefaults

  enum Options: String {
    case favorites = "cpdrm-favorites"
  }

  enum Limits: Int {
    case favorites = 1
  }

  private init() {
    defaults = UserDefaults.standard
  }

  func read(option: Options) -> Any {
    switch option {
    case .favorites:
      guard let favorites = defaults.array(forKey: option.rawValue) else {
        return []
      }
      return favorites
    }
  }

  func write(option: Options, withValue value: Any) {
    defaults.setValue(value, forKey: option.rawValue)
  }

  func checkLimit(_ limit: Limits) -> Bool {
    switch limit {
    case .favorites:
      guard let favorites = defaults.array(forKey: Options.favorites.rawValue) else {
        return true
      }
      return !(favorites.count >= Limits.favorites.rawValue)
    }
  }
}
