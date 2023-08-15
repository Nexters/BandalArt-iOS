//
//  MainGoalEmojiTitleCell.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import Components

struct EmojiTitleCellViewModel {
  let title: PassthroughSubject<String?, Never>
  let emoji: PassthroughSubject<Character?, Never>
}

final class EmojiTitleCell: UICollectionViewCell {
  
  static let identifier = "EmojiTitleCell"

  weak var delegate: EmojiSelectorDelegate?
  private var cancellables = Set<AnyCancellable>()
  
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
  
  lazy var emojiView: EmojiView = {
    let emojiView = EmojiView()
    let gesture = UITapGestureRecognizer(
      target: self,
      action: #selector(emojiViewTapped)
    )
    gesture.numberOfTapsRequired = 1
    emojiView.isUserInteractionEnabled = true
    emojiView.addGestureRecognizer(gesture)
    return emojiView
  }()
  
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
    emojiView.setEmoji(with: item.emoji ?? Character(""))
    underlineTextField.text = item.title
  }
  
  func configure(with viewModel: EmojiTitleCellViewModel) {
    underlineTextField.textPublisher
      .sink { text in
        guard let text = text else { return }
        viewModel.title.send(text)
      }
      .store(in: &cancellables)
    
//    emojiView.emojiLabel
//      .publisher(for: \.text)
//      .compactMap { ($0.map{ $0 })?.first }
//      .sink { emoji in
//        viewModel.emoji.send(emoji)
//      }
//      .store(in: &cancellables)
    
    viewModel.emoji
      .sink { [weak self] emoji in
        self?.emojiView.setEmoji(with: emoji)
      }
      .store(in: &cancellables)
    
    viewModel.title
      .sink { [weak self] text in
        self?.underlineTextField.text = text
      }
      .store(in: &cancellables)
  }
  
  @objc func emojiViewTapped(_ sender: UIView) {
    delegate?.emojiViewTapped(in: self)
  }
}
