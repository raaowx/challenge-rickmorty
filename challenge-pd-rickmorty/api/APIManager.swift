//
//  APIManager.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 11/8/21.
//

import Alamofire

class APIManager {
  /**
    NOTE: `FinishHandler` & `ErrorHandler` look the same
    because at these moment we don't need to throw an error code from requests.
    Although, we keep it separete for readability purposes.
  */
  typealias FinishHandler = () -> Void
  typealias ErrorHandler = () -> Void

  internal static let BaseURL = "https://rickandmortyapi.com/api"
}
