//
//  EmojiCell.swift
//  BottomSheetFeature
//
//  Created by Sang hun Lee on 2023/08/09.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Components

final class EmojiCell: UICollectionViewCell {
  static let identifier = "EmojiCell"
  
  override var isSelected: Bool {
    willSet {
      updateSelectedState(isSelected: newValue)
    }
  }
  
  lazy var strokeView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.layer.borderWidth = 1.0
    view.layer.borderColor = UIColor.gray400.cgColor
    view.layer.cornerRadius = 16.0
    view.isHidden = true
    return view
  }()
  
  lazy var emojiView: EmojiView = {
    let emojiView = EmojiView()
    return emojiView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    [emojiView, strokeView].forEach {
      contentView.addSubview($0)
    }
  }
  
  private func setupConstraints() {
    emojiView.snp.makeConstraints {
      $0.edges.equalTo(contentView).inset(1.0)
    }
    
    strokeView.snp.makeConstraints {
      $0.edges.equalTo(contentView)
    }
  }
  
  public func setupData(item: EmojiItem) {
    emojiView.setEmoji(with: item.emoji ?? Character(""))
  }
  
  func updateSelectedState(isSelected: Bool) {
    strokeView.isHidden = !isSelected
  }
}
