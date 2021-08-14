//
//  UIUnitTest.swift
//  challenge-pd-rickmortyUITests
//
//  Created by raaowx on 10/8/21.
//

import XCTest

class UIUnitTest: XCTestCase {
  func testAppLaunch() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testScrollListThreeTimes() throws {
    let app = XCUIApplication()
    app.launch()
    let table = app.tables.element
    let visibleCells = table.cells
    for _ in 0..<3 {
      table.swipeUp()
    }
    XCTAssertFalse(visibleCells == table.cells)
  }

  func testSearchBar() throws {
    let app = XCUIApplication()
    app.launch()
    let searchBar = app.searchFields.element
    searchBar.tap()
    app.keys["s"].tap()
    app.keys["m"].tap()
    app.keys["i"].tap()
    app.keys["t"].tap()
    app.keys["h"].tap()
    XCTAssertFalse((searchBar.value as? String)?.isEmpty ?? true)
  }
}
