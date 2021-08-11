//
//  LocationUnitTest.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 11/8/21.
//

import XCTest
@testable import challenge_pd_rickmorty

class LocationUnitTest: XCTestCase {
  func testCompleteJsonCreatesObject() {
    let locationStr = """
      {
      "id": 3,
      "name": "Citadel of Ricks",
      "type": "Space station",
      "dimension": "unknown",
      "residents": [
        "https://rickandmortyapi.com/api/character/8",
        "https://rickandmortyapi.com/api/character/14",
      ],
      "url": "https://rickandmortyapi.com/api/location/3",
      "created": "2017-11-10T13:08:13.191Z"
      }
      """
    guard let locationData = locationStr.data(using: .utf8) else { return }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Location.TimestampFormatter)
    XCTAssertNotNil(try decoder.decode(Location.self, from: locationData))
  }

  func testMinimalJsonCreatesObject() {
    let locationStr = """
      {
      "name": "Citadel of Ricks",
      "url": "https://rickandmortyapi.com/api/location/3"
      }
      """
    guard let locationData = locationStr.data(using: .utf8) else { return }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Location.TimestampFormatter)
    XCTAssertNotNil(try decoder.decode(Location.self, from: locationData))
  }

  func testEmptyJsonThrow() {
    let locationStr = "{}"
    guard let locationData = locationStr.data(using: .utf8) else { return }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Location.TimestampFormatter)
    XCTAssertThrowsError(try decoder.decode(Location.self, from: locationData))
  }

  func testIncompleteJsonThrow() {
    let locationStr = """
      {
      "name": "Citadel of Ricks"
      }
      """
    guard let locationData = locationStr.data(using: .utf8) else { return }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Location.TimestampFormatter)
    XCTAssertThrowsError(try decoder.decode(Location.self, from: locationData))
  }

  func testWrongDataTypeThrow() {
    let locationStr = """
      {
      "name": "Citadel of Ricks",
      "url": 3
      }
      """
    guard let locationData = locationStr.data(using: .utf8) else { return }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Location.TimestampFormatter)
    XCTAssertThrowsError(try decoder.decode(Location.self, from: locationData))
  }
}
