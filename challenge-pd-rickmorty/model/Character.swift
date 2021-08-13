//
//  Character.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 11/8/21.
//

import Foundation

struct Character: Codable {
  /**
    NOTE: We don't need to apply `private(set)` protection level
    because these constant properties are already in `read-only` mode.
  */
  let id: Int
  let name: String
  let status: Status
  let species: String
  let type: String
  let gender: Gender
  let origin: Location
  let location: Location
  let image: URL
  let episode: [URL]
  let created: Date

  enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown
  }

  enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown
  }

  static func getTSFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
    return dateFormatter
  }
}

// MARK: - Helpers
extension Character {
  /**
    The API REST serves dates as a string timestamp with format `yyyy-MM-dd'T'HH:mm:ss.SSSX`.
  */
  static var TimestampFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
    return dateFormatter
  }
}
