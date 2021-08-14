//
//  CharactersViewController.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 10/8/21.
//

import UIKit

class CharactersViewController: UIViewController {
  @IBOutlet weak var favoritesContainerV: UIView!
  @IBOutlet weak var favoritesPC: UIPageControl!
  @IBOutlet weak var favV: UIView!
  @IBOutlet weak var favProfilePicIV: UIImageView!
  @IBOutlet weak var favStatusV: UIView!
  @IBOutlet weak var favNameL: UILabel!
  @IBOutlet weak var favStatusIV: UIImageView!
  @IBOutlet weak var favStatusL: UILabel!
  @IBOutlet weak var favSpeciesL: UILabel!
  @IBOutlet weak var favLocationIV: UIImageView!
  @IBOutlet weak var favLocationB: UIButton!
  @IBOutlet weak var charactersSB: UISearchBar!
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
  @IBOutlet weak var bigProfilePicOverlayV: UIView!
  @IBOutlet weak var bigProfilePicIV: UIImageView!
  static let prefetchLimit = 7
  var refreshControl = UIRefreshControl()
  var characters: [Character] = []
  var filteredCharacters: [Character] = []
  var favorites: [Character] = []
  var searching: Bool {
    return !(charactersSB.text?.isEmpty ?? true)
  }
  var bigProfilePicOriginalTransform: CGAffineTransform?
  var bigProfilePicOriginalCenter: CGPoint?
  var presenter: CharacterPresenter?

  override func viewDidLoad() {
    super.viewDidLoad()
    if let color = UIColor(named: "cpdrm-palatinate-purple") {
      refreshControl.tintColor = color
      locationInfoContainerV.layer.borderColor = color.cgColor
      bigProfilePicIV.layer.borderColor = color.cgColor
      if let textfield = charactersSB.value(forKey: "searchField") as? UITextField {
        textfield.textColor = color
      }
    }
    if let color = UIColor(named: "cpdrm-blue-yonder"),
      let cancelbutton = charactersSB.value(forKey: "cancelButton") as? UIButton {
      cancelbutton.setTitleColor(color, for: .normal)
    }
    if let color = UIColor(named: "cpdrm-orange-yellow-crayola") {
      favV.layer.borderColor = color.cgColor
      favProfilePicIV.layer.borderColor = color.cgColor
    }
    favV.layer.borderWidth = 2.0
    favV.layer.cornerRadius = 15
    favV.layer.shadowColor = UIColor.black.cgColor
    favV.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
    favV.layer.shadowOpacity = 0.5
    favV.layer.shadowRadius = 2.5
    favProfilePicIV.layer.borderWidth = 1.5
    favProfilePicIV.layer.cornerRadius = favProfilePicIV.bounds.height / 2
    favStatusV.layer.cornerRadius = favStatusV.bounds.height / 2
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
    bigProfilePicIV.layer.borderWidth = 1.5
    // Search Bar  & Table View
    charactersSB.delegate = self
    refreshControl.addTarget(self, action: #selector(reloadFullCharacterList), for: .valueChanged)
    charactersTV.addSubview(refreshControl)
    charactersTV.dataSource = self
    charactersTV.prefetchDataSource = self
    charactersTV.delegate = self
    // Presenter
    presenter = CharacterPresenter(delegate: self)
    presenter?.retreiveFavorites()
    programaticallyReloadFullCharacterList()
  }

  @IBAction func scrollToTop(_ sender: UIButton) {
    charactersTV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
  }

  @IBAction func closeLocation(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3) {
      self.locationInfoOverlayV.isHidden = true
    }
    locCharacterNameL.text = nil
    locationLoadingAIV.stopAnimating()
    locationInfoV.isHidden = true
    locNameL.text = nil
    locTypeL.text = nil
    locDimensionL.text = nil
    locAgeL.text = nil
    locTotalCharactersL.text = nil
  }

  @IBAction func showFavLocationInfo(_ sender: Any) {
    if favorites.indices.contains(favoritesPC.currentPage) {
      showLocationInfo(
        favorites[favoritesPC.currentPage].location.url,
        forCharacter: favorites[favoritesPC.currentPage].name)
    }
  }

  @IBAction func showFavProfilePic(_ sender: UITapGestureRecognizer) {
    if let color = UIColor(named: "cpdrm-orange-yellow-crayola") {
      bigProfilePicIV.layer.borderColor = color.cgColor
    }
    bigProfilePicIV.image = favProfilePicIV.image
    bigProfilePicIV.layer.cornerRadius = bigProfilePicIV.bounds.height / 2
    bigProfilePicOriginalTransform = bigProfilePicIV.transform
    bigProfilePicOriginalCenter = bigProfilePicIV.center
    UIView.animate(withDuration: 0.3) {
      self.bigProfilePicOverlayV.isHidden = false
    }
  }

  @IBAction func removeAsFavorite(_ sender: UIButton) {
    let index = favoritesPC.currentPage
    if favorites.indices.contains(index) {
      let id = favorites[index].id
      presenter?.removeFavoriteCharacter(id)
      if let row = (searching) ?
        filteredCharacters.firstIndex(where: { $0.id == id }) :
        characters.firstIndex(where: { $0.id == id }),
        let cell = charactersTV.cellForRow(at: IndexPath(row: row, section: 0)) as? CharacterCell {
        cell.updateFavoriteStatus()
      }
    }
  }

  @IBAction func zoomBigProfilePic(_ sender: UIPinchGestureRecognizer) {
    guard let view = sender.view else { return }
    let transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
    view.transform = transform
    sender.scale = 1
  }

  @IBAction func panBigProfilePic(_ sender: UIPanGestureRecognizer) {
    guard let view = sender.view else { return }
    let translation = sender.translation(in: view)
    view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
    sender.setTranslation(.zero, in: view)
  }

  @IBAction func doubleTapBigProfilePic(_ sender: UITapGestureRecognizer) {
    if let transform = self.bigProfilePicOriginalTransform,
      let center = self.bigProfilePicOriginalCenter {
      self.bigProfilePicIV.transform = transform
      self.bigProfilePicIV.center = center
    }
  }

  @IBAction func closeBigProfilePic(_ sender: Any) {
    UIView.animate(withDuration: 0.3, animations: {
      self.bigProfilePicOverlayV.isHidden = true
    }, completion: { _ in
      self.bigProfilePicIV.image = nil
      if let original = self.bigProfilePicOriginalTransform {
        self.bigProfilePicIV.transform = original
      }
      if let original = self.bigProfilePicOriginalCenter {
        self.bigProfilePicIV.center = original
      }
      if let color = UIColor(named: "cpdrm-palatinate-purple") {
        self.bigProfilePicIV.layer.borderColor = color.cgColor
      }
    })
  }

  @objc func reloadFullCharacterList() {
    presenter?.retreiveCharacters(fromFirstPage: true)
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

  func reloadFavorites(with characters: [Character]) {
    favorites = characters
    guard let first = characters.first else {
      UIView.animate(withDuration: 0.3, animations: {
        self.favoritesContainerV.isHidden = true
      }, completion: { _ in
        self.favNameL.text = nil
        self.favStatusL.text = nil
        self.favSpeciesL.text = nil
        self.favLocationB.setTitle(nil, for: .normal)
        self.favStatusV.backgroundColor = .darkGray
        self.favProfilePicIV.image = UIImage(
          systemName: "person.fill",
          withConfiguration: UIImage.SymbolConfiguration(
            pointSize: 21.0,
            weight: .regular,
            scale: .medium))
        self.favStatusIV.image = UIImage(
          systemName: "questionmark.circle",
          withConfiguration: UIImage.SymbolConfiguration(
            pointSize: 17.0,
            weight: .regular,
            scale: .medium))
        self.favLocationIV.image = nil
        self.favoritesPC.numberOfPages = 1
        self.favoritesPC.currentPage = 0
      })
      return
    }
    favNameL.text = first.name
    favStatusL.text = first.status.rawValue.capitalized
    favSpeciesL.text = first.species.capitalized
    favLocationB.setTitle(first.location.name, for: .normal)
    let configuration = UIImage.SymbolConfiguration(pointSize: 17.0, weight: .regular, scale: .medium)
    switch first.status {
    case .alive:
      favStatusV.backgroundColor = .systemGreen
      favStatusIV.image = UIImage(systemName: "heart.fill", withConfiguration: configuration)
    case .dead:
      favStatusV.backgroundColor = .systemRed
      favStatusIV.image = UIImage(systemName: "bolt.heart", withConfiguration: configuration)
    case .unknown:
      favStatusV.backgroundColor = .darkGray
      favStatusIV.image = UIImage(systemName: "questionmark.circle", withConfiguration: configuration)
    }
    if first.location.name == "unknown" {
      favLocationB.isEnabled.toggle()
      favLocationIV.image = UIImage(systemName: "mappin.slash", withConfiguration: configuration)
    } else {
      favLocationIV.image = UIImage(systemName: "mappin", withConfiguration: configuration)
    }
    AssetsAPIManager.getImage(first.image, onCompletion: { [self] image in
      favProfilePicIV.image = image
    }, onError: { })
    favoritesPC.numberOfPages = characters.count
    favoritesPC.currentPage = 0
    if let row = (searching) ?
      filteredCharacters.firstIndex(where: { $0.id == first.id }) :
      self.characters.firstIndex(where: { $0.id == first.id }),
      let cell = charactersTV.cellForRow(at: IndexPath(row: row, section: 0)) as? CharacterCell {
      cell.updateFavoriteStatus()
    }
    UIView.animate(withDuration: 0.3) {
      self.favoritesContainerV.isHidden = false
    }
  }

  func completeLocationInfo(with location: Location) {
    locNameL.text = location.name
    locTypeL.text = location.type ?? "---"
    locDimensionL.text = location.dimension ?? "---"
    let age = location.created?.ageInYears ?? 0
    locAgeL.text = (age == 0) ?
      String(format: NSLocalizedString("charactersvc-year", comment: ""), age) :
      String(format: NSLocalizedString("charactersvc-years", comment: ""), age)
    locTotalCharactersL.text = "\(location.residents?.count ?? 1)"
    locationLoadingAIV.stopAnimating()
    UIView.animate(withDuration: 0.3) {
      self.locationInfoV.isHidden = false
    }
  }

  func showListFetchError() {
    Alerts.showError(over: self, withError: .characterReq)
  }

  func showLocationFetchError() {
    Alerts.showError(over: self, withError: .locationReq)
  }

  func showFavoriteFetchError() {
    Alerts.showError(over: self, withError: .favoriteReq)
  }

  func showFavoriteLimitError() {
    Alerts.showError(over: self, withError: .favoriteLimit)
  }
}

// MARK: - Characters Cell Delegate
extension CharactersViewController: CharacterCellDelegate {
  func showLocationInfo(_ url: URL, forCharacter name: String) {
    charactersSB.resignFirstResponder()
    locCharacterNameL.text = name
    locationLoadingAIV.startAnimating()
    UIView.animate(withDuration: 0.3) {
      self.locationInfoOverlayV.isHidden = false
    }
    presenter?.retreiveLocation(from: url)
  }

  func showProfilePic(_ image: UIImage, forCharacterId id: Int) {
    bigProfilePicIV.image = image
    bigProfilePicIV.layer.cornerRadius = bigProfilePicIV.bounds.height / 2
    bigProfilePicOriginalTransform = bigProfilePicIV.transform
    bigProfilePicOriginalCenter = bigProfilePicIV.center
    if let presenter = presenter,
      presenter.iAmAFavoriteCharacter(id),
      let color = UIColor(named: "cpdrm-orange-yellow-crayola") {
      bigProfilePicIV.layer.borderColor = color.cgColor
    }
    UIView.animate(withDuration: 0.3) {
      self.bigProfilePicOverlayV.isHidden = false
    }
  }

  func saveAsFavorite(_ id: Int) {
    presenter?.saveFavoriteCharacter(id)
  }
}

// MARK: - UITableView DataSource & Delegate
extension CharactersViewController: UITableViewDataSource, UITableViewDataSourcePrefetching, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searching {
      return filteredCharacters.count
    }
    return characters.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: CharacterCell.cellIdentifier) as? CharacterCell else {
      return UITableViewCell()
    }
    cell.setupUI(forCharacter: (searching) ? filteredCharacters[indexPath.item] : characters[indexPath.item])
    cell.delegate = self
    cell.presenter = presenter
    return cell
  }

  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    let sortedIndexPaths = indexPaths.sorted()
    if let lastIndexPath = sortedIndexPaths.last,
      CharactersViewController.prefetchLimit >= (characters.count - lastIndexPath.item) {
      presenter?.retreiveCharacters(fromFirstPage: false)
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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let character = (searching) ?
      filteredCharacters[indexPath.item] :
      characters[indexPath.item]
    showLocationInfo(character.location.url, forCharacter: character.name)
  }
}

// MARK: - UISearchBar Delegate
extension CharactersViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text?.removeAll()
    searchBar.resignFirstResponder()
    filteredCharacters.removeAll()
    charactersTV.reloadData()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    charactersTV.reloadData()
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      filteredCharacters.removeAll()
    } else {
      filteredCharacters = characters.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    charactersTV.reloadData()
  }
}
