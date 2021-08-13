//
//  Alerts.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 13/8/21.
//

import UIKit

class Alerts: UIAlertController {
  enum CPDRMError {
    // Request
    case characterReq
    case locationReq
    var title: String {
      switch self {
      case .characterReq,
        .locationReq:
        return "Error"
      }
    }
    var message: String {
      switch self {
      case .characterReq:
        return """
          Ups! Something goes wrong while looking for Rick & Morty.
          Please, try again in a while.
          """
      case .locationReq:
        return """
          Ups! Something goes wrong while retrieving location data.
          Please, try again in a while.
          """
      }
    }
  }

  static func showError(over uivc: UIViewController, withError error: CPDRMError) {
    let close = UIAlertAction(title: "Ok", style: .default)
    let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
    alert.addAction(close)
    uivc.present(alert, animated: true)
  }
}
