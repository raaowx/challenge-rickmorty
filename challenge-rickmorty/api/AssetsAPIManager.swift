//
//  AssetsAPIManager.swift
//  challenge-rickmorty
//
//  Created by raaowx on 11/8/21.
//

import Alamofire
import AlamofireImage

class AssetsAPIManager: APIManager {
  typealias CompletionHandler = (_ image: Image) -> Void

  /**
    Download an image.
    - parameter url: Download URL
    - parameter onCompletion: Closure to execute when request is completed successfully
    - parameter onError: Closure to execute when request fails
  */
  static func getImage(_ url: URL, onCompletion: @escaping CompletionHandler, onError: @escaping ErrorHandler) {
    AF.request(url)
    .responseImage { afdr in
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
        onError()
        return
      }
      do {
        let image = try afdr.result.get()
        onCompletion(image)
      } catch {
        print("\(#function):[\(#line)] => Error: \(error.localizedDescription)")
        onError()
      }
    }
  }
}
