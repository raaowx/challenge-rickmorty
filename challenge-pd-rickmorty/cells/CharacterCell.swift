//
//  CharacterCell.swift
//  challenge-pd-rickmorty
//
//  Created by raaowx on 12/8/21.
//

import UIKit

protocol CharacterCellDelegate: AnyObject {
  func showLocationInfo(_ url: URL, forCharacter name: String)
  func saveAsFavorite(_ id: Int)
}

class CharacterCell: UITableViewCell {
  @IBOutlet private weak var containerV: UIView!
  @IBOutlet private weak var profilePicIV: UIImageView!
  @IBOutlet private weak var statusV: UIView!
  @IBOutlet private weak var nameL: UILabel!
  @IBOutlet private weak var favoriteB: UIButton!
  @IBOutlet private weak var statusIV: UIImageView!
  @IBOutlet private weak var statusL: UILabel!
  @IBOutlet private weak var speciesL: UILabel!
  @IBOutlet private weak var locationIV: UIImageView!
  @IBOutlet private weak var locationB: UIButton!
  static let cellIdentifier = "characterCell"
  weak var delegate: CharacterCellDelegate?
  private var character: Character?

  @IBAction func showLocationInfo(_ sender: UIButton) {
    guard let character = self.character else { return }
    delegate?.showLocationInfo(character.location.url, forCharacter: character.name)
  }

  @IBAction private func saveAsFavorite(_ sender: UIButton) {
    guard let character = self.character else { return }
    delegate?.saveAsFavorite(character.id)
  }

  func setupUI(forCharacter character: Character) {
    // Character
    self.character = character
    // UI
    if let color = UIColor(named: "cpdrm-palatinate-purple") {
      containerV.layer.borderColor = color.cgColor
      profilePicIV.layer.borderColor = color.cgColor
    }
    containerV.layer.borderWidth = 1.25
    containerV.layer.cornerRadius = 15
    containerV.layer.shadowColor = UIColor.black.cgColor
    containerV.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
    containerV.layer.shadowOpacity = 0.5
    containerV.layer.shadowRadius = 2.5
    profilePicIV.layer.borderWidth = 1.0
    profilePicIV.layer.cornerRadius = profilePicIV.bounds.height / 2
    statusV.layer.cornerRadius = statusV.bounds.height / 2
    // Text
    nameL.text = character.name
    statusL.text = character.status.rawValue.capitalized
    speciesL.text = character.species.capitalized
    locationB.setTitle(character.location.name, for: .normal)
    // Icons
    let configuration = UIImage.SymbolConfiguration(pointSize: 17.0, weight: .regular, scale: .medium)
    switch character.status {
    case .alive:
      statusV.backgroundColor = .systemGreen
      statusIV.image = UIImage(systemName: "heart.fill", withConfiguration: configuration)
    case .dead:
      statusV.backgroundColor = .systemRed
      statusIV.image = UIImage(systemName: "bolt.heart", withConfiguration: configuration)
    default: break
    }
    if character.location.name == "unknown" {
      locationB.isEnabled.toggle()
      locationIV.image = UIImage(systemName: "mappin.slash", withConfiguration: configuration)
    } else {
      locationIV.image = UIImage(systemName: "mappin", withConfiguration: configuration)
    }
    // Images
    AssetsAPIManager.getImage(character.image, onCompletion: { [self] image in
      profilePicIV.image = image
    }, onError: { })
  }
}
