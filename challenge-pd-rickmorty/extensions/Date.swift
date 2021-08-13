//
//  Date.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 13/8/21.
//

import Foundation

extension Date {
  var ageInYears: Int {
    guard let year = Calendar.current.dateComponents([.year], from: self).year,
      let currentYear = Calendar.current.dateComponents([.year], from: Date()).year else {
      return 0
    }
    return currentYear - year
  }
}
