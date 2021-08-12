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
      if page == 1 {
        delegate?.showListFetchError()
      }
    })
  }
}
