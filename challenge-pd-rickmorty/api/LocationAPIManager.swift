//
//  LocationAPIManager.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 11/8/21.
//

import Alamofire

class LocationAPIManager: APIManager {
  typealias CompletionHandler = (_ location: Location) -> Void

  enum Endpoints: String {
    case location = "/location"
    var method: HTTPMethod {
      switch self {
      case .location: return .get
      }
    }
  }

  /**
    Get location definition for a given url.
    - parameter url: Location url
    - parameter onCompletion: Closure to execute when request is completed successfully
    - parameter onError: Closure to execute when request fails
  */
  static func getLocation(_ url: URL, onCompletion: @escaping CompletionHandler, onError: @escaping ErrorHandler) {
    AF.request(
      url,
      method: Endpoints.location.method
    )
    .responseJSON { afdr in
      if let error = afdr.error {
        print("\(#function):[\(#line)] => Error: \(error.localizedDescription)")
        onError()
        return
      }
      guard let response = afdr.response else {
        print("\(#function):[\(#line)] => Error unwrapping response")
        onError()
        return
      }
      if response.statusCode != 200 {
        print("\(#function):[\(#line)] => Unexpected Status Code: \(response.statusCode)")
      }
      guard let data = afdr.data else {
        print("\(#function):[\(#line)] => Error unwrapping data")
        onError()
        return
      }
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(Location.TimestampFormatter)
      do {
        let location = try decoder.decode(Location.self, from: data)
        onCompletion(location)
      } catch {
        print("\(#function):[\(#line)] => Error: \(error.localizedDescription)")
        onError()
      }
    }
  }
}
