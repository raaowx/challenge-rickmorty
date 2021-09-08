//
//  SettingsUnitTest.swift
//  challenge-rickmortyTests
//
//  Created by raaowx on 13/8/21.
//

import XCTest
@testable import challenge_rickmorty

class SettingsUnitTest: XCTestCase {
  func testFavoritesReceiveArray() {
    XCTAssertNotNil(Settings.shared.read(option: .favorites) as? [Int])
  }

  func testFavoritesLimitCheck() {
    XCTAssertNotNil(Settings.shared.checkLimit(.favorites))
  }
}
