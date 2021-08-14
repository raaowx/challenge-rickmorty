//
//  CharactersPresenter.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 12/8/21.
//

import Foundation

protocol CharactersDelegate: AnyObject {
  // Change UI
  func reloadCharacterList(with characters: [Character])
  func reloadFavorites(with characters: [Character])
  func completeLocationInfo(with location: Location)
  // Errors
  func showListFetchError()
  func showLocationFetchError()
  func showFavoriteFetchError()
  func showFavoriteLimitError()
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
      delegate?.showListFetchError()
    })
  }

  func retreiveLocation(from url: URL) {
    LocationAPIManager.getLocation(url, onCompletion: { [self] location in
      delegate?.completeLocationInfo(with: location)
    }, onError: { [self] in
      delegate?.showLocationFetchError()
    })
  }

  func retreiveFavorites() {
    guard let favorites = Settings.shared.read(option: .favorites) as? [Int],
      !favorites.isEmpty else {
      delegate?.reloadFavorites(with: [])
      return
    }
    CharacterAPIManager.getCharacters(favorites, onCompletion: { [self] characters in
      delegate?.reloadFavorites(with: characters)
    }, onError: { [self] in
      delegate?.reloadFavorites(with: [])
      delegate?.showFavoriteFetchError()
    })
  }

  func iAmAFavoriteCharacter(_ id: Int) -> Bool {
    guard let favorites = Settings.shared.read(option: .favorites) as? [Int] else {
      return false
    }
    return favorites.contains(id)
  }

  func saveFavoriteCharacter(_ id: Int) {
    guard Settings.shared.checkLimit(.favorites) else {
      delegate?.showFavoriteLimitError()
      return
    }
    /**
      NOTE: This procedure set new favorite in the first position
    */
    var newFavorites = [id]
    if let favorites = Settings.shared.read(option: .favorites) as? [Int] {
      if favorites.contains(id) {
        retreiveFavorites()
        return
      }
      newFavorites.append(contentsOf: favorites)
    }
    Settings.shared.write(option: .favorites, withValue: newFavorites)
    retreiveFavorites()
  }

  func removeFavoriteCharacter(_ id: Int) {
    guard let favorites = Settings.shared.read(option: .favorites) as? [Int],
      !favorites.isEmpty else {
      delegate?.reloadFavorites(with: [])
      return
    }
    let newFavorites = favorites.filter { return $0 != id }
    Settings.shared.write(option: .favorites, withValue: newFavorites)
    retreiveFavorites()
  }
}
