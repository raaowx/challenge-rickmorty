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
  /**
    NOTE: FIFO queue to handle page fetching process
    and don't miss any page. It will contain `-1` when we reach
    the end of the pages (a.k.a receive a `HTTP Status Code = 404`).
  */
  private var pagesToFetch = [1]
  /**
    NOTE: Handle if we're already fetching a page
    so we don't download the same page twice or more
    times.
  */
  private var downloadInCourse = false

  init(delegate: CharactersDelegate) {
    self.delegate = delegate
  }

  func retreiveCharacters(fromFirstPage firstPage: Bool) {
    if downloadInCourse {
      return
    }
    if firstPage {
      characters.removeAll()
      pagesToFetch = [1]
    }
    guard let page = pagesToFetch.first else {
      delegate?.showListFetchError()
      return
    }
    if page == -1 { return }
    downloadInCourse.toggle()
    CharacterAPIManager.getPage(page, onCompletion: { [self] newCharacters in
      pagesToFetch.append(page + 1)
      pagesToFetch.removeFirst()
      characters.append(contentsOf: newCharacters)
      characters.sort { $0.id < $1.id }
      downloadInCourse.toggle()
      delegate?.reloadCharacterList(with: characters)
    }, onFinish: { [self] in
      downloadInCourse.toggle()
      pagesToFetch = [-1]
    },
    onError: { [self] in
      downloadInCourse.toggle()
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
