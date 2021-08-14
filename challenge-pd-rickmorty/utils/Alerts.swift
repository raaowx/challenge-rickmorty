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
    case favoriteReq
    case favoriteLimit
    var title: String {
      switch self {
      case .characterReq,
        .locationReq,
        .favoriteReq,
        .favoriteLimit:
        return "alerts-title-error"
      }
    }
    var message: String {
      switch self {
      case .characterReq:
        return "alerts-msg-character-req"
      case .locationReq:
        return "alerts-msg-location-req"
      case .favoriteReq:
        return "alerts-msg-favorite-req"
      case .favoriteLimit:
        return "alerts-msg-favorite-limit"
      }
    }
  }

  static func showError(over uivc: UIViewController, withError error: CPDRMError) {
    let close = UIAlertAction(
      title: NSLocalizedString("alerts-btn-ok", comment: ""),
      style: .default)
    let alert = UIAlertController(
      title: NSLocalizedString(error.title, comment: ""),
      message: NSLocalizedString(error.message, comment: ""),
      preferredStyle: .alert)
    alert.addAction(close)
    uivc.present(alert, animated: true)
  }
}
