//
//  CharacterUnitTest.swift
//  challenge-pd-rickmortyTests
//
//  Created by raaowx on 10/8/21.
//

import XCTest
@testable import challenge_pd_rickmorty

class CharacterUnitTest: XCTestCase {
  func testCompleteJsonCreatesObject() {
    let characterStr = """
      {
        "id": 2,
        "name": "Morty Smith",
        "status": "Alive",
        "species": "Human",
        "type": "",
        "gender": "Male",
        "origin": {
          "name": "Earth",
          "url": "https://rickandmortyapi.com/api/location/1"
        },
        "location": {
          "name": "Earth",
          "url": "https://rickandmortyapi.com/api/location/20"
        },
        "image": "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
        "episode": [
          "https://rickandmortyapi.com/api/episode/1",
          "https://rickandmortyapi.com/api/episode/2"
        ],
        "url": "https://rickandmortyapi.com/api/character/2",
        "created": "2017-11-04T18:50:21.651Z"
      }
      """
    guard let characterData = characterStr.data(using: .utf8) else { return }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Character.TimestampFormatter)
    XCTAssertNotNil(try decoder.decode(Character.self, from: characterData))
  }

  func testEmptyJsonThrow() {
    let characterStr = "{}"
    guard let characterData = characterStr.data(using: .utf8) else { return }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Character.TimestampFormatter)
    XCTAssertThrowsError(try decoder.decode(Character.self, from: characterData))
  }

  func testIncompleteJsonThrow() {
    let characterStr = """
      {
        "id": 2,
        "name": "Morty Smith",
        "status": "Alive",
        "species": "Human",
        "type": "",
        "gender": "Male",
        "image": "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
        "episode": [],
        "url": "https://rickandmortyapi.com/api/character/2",
        "created": "2017-11-04T18:50:21.651Z"
      }
      """
    guard let characterData = characterStr.data(using: .utf8) else { return }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Character.TimestampFormatter)
    XCTAssertThrowsError(try decoder.decode(Character.self, from: characterData))
  }

  func testWrongDataTypeThrow() {
    let characterStr = """
      {
        "id": 2,
        "name": "Morty Smith",
        "status": "Alive",
        "species": "Human",
        "type": "",
        "gender": "Male",
        "image": "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
        "episode": "https://rickandmortyapi.com/api/episode/2",
        "url": 2,
        "created": "2017-11-04T18:50:21.651Z"
      }
      """
    guard let characterData = characterStr.data(using: .utf8) else { return }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Character.TimestampFormatter)
    XCTAssertThrowsError(try decoder.decode(Character.self, from: characterData))
  }

  func testCompleteJsonCreatesArray() {
    let characterStr = """
      [
        {
          "id": 2,
          "name": "Morty Smith",
          "status": "Alive",
          "species": "Human",
          "type": "",
          "gender": "Male",
          "origin": {
            "name": "Earth",
            "url": "https://rickandmortyapi.com/api/location/1"
          },
          "location": {
            "name": "Earth",
            "url": "https://rickandmortyapi.com/api/location/20"
          },
          "image": "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
          "episode": [
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/2"
          ],
          "url": "https://rickandmortyapi.com/api/character/2",
          "created": "2017-11-04T18:50:21.651Z"
        },
        {
          "id": 1,
          "name": "Rick Sanchez",
          "status": "Alive",
          "species": "Human",
          "type": "",
          "gender": "Male",
          "origin": {
            "name": "Earth (C-137)",
            "url": "https://rickandmortyapi.com/api/location/1"
          },
          "location": {
            "name": "Earth (Replacement Dimension)",
            "url": "https://rickandmortyapi.com/api/location/20"
          },
          "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
          "episode": [
            "https://rickandmortyapi.com/api/episode/1"
          ],
          "url": "https://rickandmortyapi.com/api/character/1",
          "created": "2017-11-04T18:48:46.250Z"
        }
      ]
      """
    guard let characterData = characterStr.data(using: .utf8) else { return }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Character.TimestampFormatter)
    XCTAssertNotNil(try decoder.decode([Character].self, from: characterData))
  }
}
