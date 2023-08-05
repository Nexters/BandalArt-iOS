//
//  MainGoalEmojiTitleCell.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Components

final class EmojiTitleCell: UICollectionViewCell {
  static let identifier = "EmojiTitleCell"
  
  lazy var containerView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.addArrangedSubview(emojiView)
    stackView.addArrangedSubview(textFieldContainer)
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 15.0
    stackView.contentMode = .scaleToFill
    emojiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    emojiView.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    return stackView
  }()
  
  lazy var emojiView = EmojiView()
  
  lazy var textFieldContainer: UIView = {
    let view = UIView()
    view.addSubview(underlineTextField)
    underlineTextField.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(4.0)
      $0.trailing.equalToSuperview().offset(-4.0)
    }
    return view
  }()
  
  lazy var underlineTextField: UnderlineTextField = {
    let underlineTextField = UnderlineTextField()
    underlineTextField.tintColor = .gray400
    underlineTextField.placeholder = "15자 이내로 입력해주세요"
    underlineTextField.placeholderString = "15자 이내로 입력해주세요"
    return underlineTextField
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
    [containerView].forEach {
      contentView.addSubview($0)
    }
  }
  
  private func setupConstraints() {
    containerView.snp.makeConstraints {
      $0.edges.equalTo(contentView).inset(4.0)
      $0.height.greaterThanOrEqualTo(52.0)
    }

    emojiView.snp.makeConstraints {
      $0.width.equalTo(52.0)
    }
  }
  
  public func setupData(item: EmojiTitleItem) {
    emojiView.setEmoji(with: item.emoji)
    underlineTextField.text = item.title
  }
}
