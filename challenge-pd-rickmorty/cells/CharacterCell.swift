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
  @IBOutlet weak var containerV: UIView!
  @IBOutlet weak var favoriteB: UIButton!
  @IBOutlet weak var profilePicIV: UIImageView!
  @IBOutlet weak var nameL: UILabel!
  @IBOutlet weak var statusIV: UIImageView!
  @IBOutlet weak var statusV: UIView!
  @IBOutlet weak var locationIV: UIImageView!
  @IBOutlet weak var locationB: UIButton!
  static let cellIdentifier = "characterCell"
  private var character: Character?
  weak var delegate: CharacterCellDelegate?

  @IBAction func showLocationInfo(_ sender: UIButton) {
    guard let character = self.character else { return }
    delegate?.showLocationInfo(character.location.url, forCharacter: character.name)
  }

  @IBAction private func saveAsFavorite(_ sender: UIButton) {
    guard let character = self.character else { return }
    delegate?.saveAsFavorite(character.id)
  }

  func setupUI(forCharacter character: Character) {
    self.character = character
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
    AssetsAPIManager.getImage(character.image, onCompletion: { [self] image in
      profilePicIV.image = image
    }, onError: { })
    nameL.text = character.name
    let configuration = UIImage.SymbolConfiguration(pointSize: 17.0, weight: .regular, scale: .medium)
    statusV.layer.cornerRadius = statusV.bounds.height / 2
    switch character.status {
    case .alive:
      statusIV.image = UIImage(systemName: "heart.fill", withConfiguration: configuration)
      statusV.backgroundColor = .systemGreen
    case .dead:
      statusIV.image = UIImage(systemName: "bolt.heart", withConfiguration: configuration)
      statusV.backgroundColor = .systemRed
    default: break
    }
    locationB.setTitle(character.location.name, for: .normal)
    if character.location.name == "unknown" {
      locationB.isEnabled.toggle()
      locationIV.image = UIImage(systemName: "mappin.slash", withConfiguration: configuration)
    } else {
      locationIV.image = UIImage(systemName: "mappin", withConfiguration: configuration)
    }
  }
}
