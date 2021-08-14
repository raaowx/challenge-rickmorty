//
//  CharacterAPIManager.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 11/8/21.
//

import Alamofire
import SwiftyJSON

class CharacterAPIManager: APIManager {
  typealias CompletionHandler = (_ characters: [Character]) -> Void

  enum Endpoints: String {
    case character = "/character"
    var method: HTTPMethod {
      switch self {
      case .character: return .get
      }
    }
  }

  /**
    Get characters definition list for a given page.
    - parameter page: Page number
    - parameter onCompletion: Closure to execute when request is completed successfully
    - parameter onFinish: Closure to execute when there are not more pages to download
    - parameter onError: Closure to execute when request fails
  */
  static func getPage(_ page: Int, onCompletion: @escaping CompletionHandler, onFinish: @escaping FinishHandler, onError: @escaping ErrorHandler) {
    let url = "\(APIManager.BaseURL)\(Endpoints.character.rawValue)?page=\(page)"
    AF.request(
      url,
      method: Endpoints.character.method
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
        if response.statusCode == 404 {
          onFinish()
          return
        }
        print("\(#function):[\(#line)] => Unexpected Status Code: \(response.statusCode)")
        onError()
        return
      }
      guard let value = afdr.value else {
        print("\(#function):[\(#line)] => Error unwrapping response value")
        onError()
        return
      }
      let json = JSON(value)
      guard let array = json["results"].array else {
        print("\(#function):[\(#line)] => Error unwrapping result array")
        onError()
        return
      }
      var characters: [Character] = []
      if array.isEmpty {
        onCompletion(characters)
      }
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(Character.TimestampFormatter)
      /**
        NOTE: By iterating over the json array we're prioritising
        showing some characters to the user instead of an empty
        list when we found an incomplete character definition json.
      */
      for obj in array {
        do {
          let data = try obj.rawData()
          let character = try decoder.decode(Character.self, from: data)
          characters.append(character)
        } catch {
          print("\(#function):[\(#line)] => Error: \(error.localizedDescription)")
          continue
        }
      }
      onCompletion(characters)
    }
  }

  /**
    Get characters definition list for an id list.
    - parameter ids: Array of character unique identifier
    - parameter onCompletion: Closure to execute when request is completed successfully
    - parameter onError: Closure to execute when request fails
  */
  static func getCharacters(_ ids: [Int], onCompletion: @escaping CompletionHandler, onError: @escaping ErrorHandler) {
    let param = ids.compactMap { String($0) }.joined(separator: ",")
    let url = "\(APIManager.BaseURL)\(Endpoints.character.rawValue)/\(param)"
    AF.request(
      url,
      method: Endpoints.character.method
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
        onError()
        return
      }
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(Character.TimestampFormatter)
      var characters: [Character] = []
      if ids.count > 1 {
        guard let value = afdr.value else {
          print("\(#function):[\(#line)] => Error unwrapping value")
          onError()
          return
        }
        let json = JSON(value)
        guard let array = json.array else {
          print("\(#function):[\(#line)] => Error unwrapping array")
          onError()
          return
        }
        if array.isEmpty {
          onCompletion(characters)
        }
        /**
          NOTE: By iterating over the json array we're prioritising
          showing some characters to the user instead of an empty
          list when we found an incomplete character definition json.
        */
        for obj in array {
          do {
            let data = try obj.rawData()
            let character = try decoder.decode(Character.self, from: data)
            characters.append(character)
          } catch {
            print("\(#function):[\(#line)] => Error: \(error.localizedDescription)")
            continue
          }
        }
      } else {
        guard let data = afdr.data else {
          print("\(#function):[\(#line)] => Error unwrapping data")
          onError()
          return
        }
        do {
          let character = try decoder.decode(Character.self, from: data)
          characters.append(character)
        } catch {
          print("\(#function):[\(#line)] => Error: \(error.localizedDescription)")
          onError()
          return
        }
      }
      onCompletion(characters)
    }
  }
}
