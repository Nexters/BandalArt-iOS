//
//  MainGoalEmojiTitleCell.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit

final class MainGoalEmojiTitleCell: UICollectionViewCell {
  static let identifier = "MainGoalEmojiTitleCell"
  
  lazy var containerView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
//    stackView.addArrangedSubview()
//    stackView.addArrangedSubview()
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.spacing = 15.0
    stackView.contentMode = .scaleToFill
    return stackView
  }()
}
