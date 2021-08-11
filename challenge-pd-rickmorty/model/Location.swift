//
//  Location.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 11/8/21.
//

import Foundation

struct Location: Codable {
  let id: Int?
  let name: String
  let type: String?
  let dimension: String?
  let residents: [URL]?
  let url: URL
  let created: Date?
}

// MARK: - Helpers
extension Location {
  /**
    The API REST serves dates as a string timestamp with format `yyyy-MM-dd'T'HH:mm:ss.SSSX`.
  */
  static var TimestampFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
    return dateFormatter
  }
}
