//
//  CharactersViewController.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 10/8/21.
//

import UIKit

class CharactersViewController: UIViewController {
  @IBOutlet weak var charactersTV: UITableView!
  @IBOutlet weak var scrollToTopB: UIButton!
  static let prefetchLimit = 7
  var refreshControl = UIRefreshControl()
  var characters: [Character] = []
  var page = 1
  var presenter: CharacterPresenter?

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = CharacterPresenter(delegate: self)
    refreshControl.attributedTitle = NSAttributedString(
      string: "Looking for Rick & Morty",
      attributes: [
        .font: UIFont.systemFont(ofSize: 21, weight: .semibold)
      ])
    refreshControl.addTarget(self, action: #selector(reloadFullCharacterList), for: .valueChanged)
    charactersTV.addSubview(refreshControl)
    charactersTV.dataSource = self
    charactersTV.prefetchDataSource = self
    charactersTV.delegate = self
    programaticallyReloadFullCharacterList()
  }

  @IBAction func scrollToTop(_ sender: UIButton) {
    charactersTV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
  }

  @objc func reloadFullCharacterList() {
    page = 1
    presenter?.retreiveCharacters(forPage: page)
  }

  func programaticallyReloadFullCharacterList() {
    characters.removeAll()
    refreshControl.beginRefreshing()
    charactersTV.reloadData()
    if charactersTV.contentOffset.y >= 0 {
      UIView.animate(withDuration: 0.3, animations: {
        self.charactersTV.contentOffset = CGPoint(x: 0.0, y: -self.refreshControl.frame.size.height)
      }, completion: { _ in
        self.reloadFullCharacterList()
      })
    }
  }
}

// MARK: - Characters Delegate
extension CharactersViewController: CharactersDelegate {
  func reloadCharacterList(with characters: [Character]) {
    self.characters = characters
    if refreshControl.isRefreshing {
      refreshControl.endRefreshing()
    }
    charactersTV.reloadData()
  }

  func showListFetchError() {
    // TODO: Show error
  }
}

// MARK: - Characters Cell Delegate
extension CharactersViewController: CharacterCellDelegate {
  func showLocationInfo(_ url: URL, forCharacter name: String) {
    print("\(#function)")
  }

  func saveAsFavorite(_ id: Int) {
    print("\(#function)")
  }
}

// MARK: - UITableView DataSource & Delegate
extension CharactersViewController: UITableViewDataSource, UITableViewDataSourcePrefetching, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return characters.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: CharacterCell.cellIdentifier) as? CharacterCell else {
      return UITableViewCell()
    }
    cell.setupUI(forCharacter: characters[indexPath.item])
    cell.delegate = self
    return cell
  }

  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    let sortedIndexPaths = indexPaths.sorted()
    if let lastIndexPath = sortedIndexPaths.last,
      CharactersViewController.prefetchLimit >= (characters.count - lastIndexPath.item) {
      page += 1
      presenter?.retreiveCharacters(forPage: page)
    }
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.item == 0 {
      UIView.animate(withDuration: 0.3) {
        self.scrollToTopB.isHidden = true
      }
    }
  }

  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.item == 0 {
      UIView.animate(withDuration: 0.3) {
        self.scrollToTopB.isHidden = false
      }
    }
  }
}
