//
//  CharactersPresenter.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 12/8/21.
//

import Foundation

protocol CharactersDelegate: AnyObject {
  func reloadCharacterList(with characters: [Character])
  func showListFetchError()
  func showLocationInfo(with location: Location)
  func showLocationFetchError()
}

class CharacterPresenter {
  private weak var delegate: CharactersDelegate?
  private var characters: [Character] = []

  init(delegate: CharactersDelegate) {
    self.delegate = delegate
  }

  func retreiveCharacters(forPage page: Int) {
    if page == 1 {
      characters.removeAll()
    }
    CharacterAPIManager.getPage(page, onCompletion: { [self] newCharacters in
      characters.append(contentsOf: newCharacters)
      delegate?.reloadCharacterList(with: characters)
    }, onError: { [self] in
      // TODO: Think about this
      if page == 1 {
        delegate?.showListFetchError()
      }
    })
  }

  func retreiveLocation(from url: URL) {
    LocationAPIManager.getLocation(url, onCompletion: { [self] location in
      delegate?.showLocationInfo(with: location)
    }, onError: { [self] in
      delegate?.showLocationFetchError()
    })
  }
}
