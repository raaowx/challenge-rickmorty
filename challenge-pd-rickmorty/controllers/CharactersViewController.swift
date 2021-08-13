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
  @IBOutlet weak var locationInfoOverlayV: UIView!
  @IBOutlet weak var locationInfoContainerV: UIView!
  @IBOutlet weak var locationInfoHeaderV: UIView!
  @IBOutlet weak var locCharacterNameL: UILabel!
  @IBOutlet weak var locationLoadingAIV: UIActivityIndicatorView!
  @IBOutlet weak var locationInfoV: UIView!
  @IBOutlet weak var locNameL: UILabel!
  @IBOutlet weak var locTypeL: UILabel!
  @IBOutlet weak var locDimensionL: UILabel!
  @IBOutlet weak var locAgeL: UILabel!
  @IBOutlet weak var locTotalCharactersL: UILabel!
  static let prefetchLimit = 7
  var refreshControl = UIRefreshControl()
  var characters: [Character] = []
  var page = 1
  var presenter: CharacterPresenter?

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = CharacterPresenter(delegate: self)
    if let color = UIColor(named: "cpdrm-palatinate-purple") {
      refreshControl.tintColor = color
      locationInfoContainerV.layer.borderColor = color.cgColor
    }
    refreshControl.addTarget(self, action: #selector(reloadFullCharacterList), for: .valueChanged)
    charactersTV.addSubview(refreshControl)
    charactersTV.dataSource = self
    charactersTV.prefetchDataSource = self
    charactersTV.delegate = self
    programaticallyReloadFullCharacterList()
    locationInfoContainerV.layer.borderWidth = 1.25
    locationInfoContainerV.layer.cornerRadius = 15
    locationInfoContainerV.layer.shadowColor = UIColor.black.cgColor
    locationInfoContainerV.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
    locationInfoContainerV.layer.shadowOpacity = 0.5
    locationInfoContainerV.layer.shadowRadius = 2.5
    locationInfoHeaderV.layer.shadowColor = UIColor.black.cgColor
    locationInfoHeaderV.layer.shadowOffset = CGSize(width: 1.25, height: 1.25)
    locationInfoHeaderV.layer.shadowOpacity = 0.25
    locationInfoHeaderV.layer.shadowRadius = 1.25
  }

  @IBAction func scrollToTop(_ sender: UIButton) {
    charactersTV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
  }

  @IBAction func closeLocation(_ sender: Any) {
    locationInfoOverlayV.isHidden = true
    locCharacterNameL.text = nil
    locationLoadingAIV.stopAnimating()
    locationInfoV.isHidden = true
    locNameL.text = nil
    locTypeL.text = nil
    locDimensionL.text = nil
    locAgeL.text = nil
    locTotalCharactersL.text = nil
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

// MARK: - Characters Presenter Delegate
extension CharactersViewController: CharactersDelegate {
  func reloadCharacterList(with characters: [Character]) {
    self.characters = characters
    if refreshControl.isRefreshing {
      refreshControl.endRefreshing()
    }
    charactersTV.reloadData()
  }

  func showLocationInfo(with location: Location) {
    locNameL.text = location.name
    locTypeL.text = location.type ?? "---"
    locDimensionL.text = location.dimension ?? "---"
    locAgeL.text = "\(location.created?.ageInYears ?? 0) years"
    locTotalCharactersL.text = "\(location.residents?.count ?? 1)"
    locationLoadingAIV.stopAnimating()
    locationInfoV.isHidden = false
  }

  func showListFetchError() {
    Alerts.showError(over: self, withError: .characterReq)
  }

  func showLocationFetchError() {
    Alerts.showError(over: self, withError: .locationReq)
  }
}

// MARK: - Characters Cell Delegate
extension CharactersViewController: CharacterCellDelegate {
  func showLocationInfo(_ url: URL, forCharacter name: String) {
    locCharacterNameL.text = name
    locationLoadingAIV.startAnimating()
    locationInfoOverlayV.isHidden = false
    presenter?.retreiveLocation(from: url)
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
