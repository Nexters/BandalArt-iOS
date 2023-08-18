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
  weak var delegate: EmojiSelectorDelegate?
  private var cancellables = Set<AnyCancellable>()
  private var viewModel: EmojiTitleCellViewModel?
  
  lazy var pencilAeccessaryImageView: UIImageView = {
    let imageView = UIImageView(image: .init(named: "pencil.circle.filled"))
    imageView.tintColor = .gray900
    imageView.isUserInteractionEnabled = false
    return imageView
  }()
  
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
    underlineTextField.font = .pretendardSemiBold(size: 16.0)
    underlineTextField.setPlaceholder(placeholder: "15자 이내로 입력해주세요", color: .gray400)
    return underlineTextField
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
    underlineTextField.delegate = self
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    bind()
  }
  
  private func setupView() {
    [containerView, pencilAeccessaryImageView].forEach {
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
    
    pencilAeccessaryImageView.snp.makeConstraints {
      $0.width.height.equalTo(18)
      $0.bottom.trailing.equalTo(emojiView).offset(4)
    }
  }
  
  public func setupData(item: EmojiTitleItem) {
    emojiView.setEmoji(with: item.emoji)
    underlineTextField.text = item.title
  }
  
  func bind() {
    underlineTextField.textPublisher
      .sink { [weak self] text in
        guard let text = text else { return }
        self?.viewModel?.title.send(text)
      }
      .store(in: &cancellables)
  }
  
  func configure(with viewModel: EmojiTitleCellViewModel) {
    self.viewModel = viewModel
    
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

extension EmojiTitleCell: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let currentText = textField.text,
       let textRange = Range(range, in: currentText) {
      let updatedText = currentText.replacingCharacters(in: textRange, with: string)
      return updatedText.count <= 15
    }
    return true
  }
}
