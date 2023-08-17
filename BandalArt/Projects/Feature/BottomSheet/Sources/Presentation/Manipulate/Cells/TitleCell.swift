//
//  TitleCell.swift
//  BottomSheetFeature
//
//  Created by Sang hun Lee on 2023/08/06.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Combine
import Components

struct TitleCellViewModel {
  let title: PassthroughSubject<String?, Never>
}

final class TitleCell: UICollectionViewCell {
  private var cancellables = Set<AnyCancellable>()
  private var viewModel: TitleCellViewModel?
  
  lazy var underlineTextField: UnderlineTextField = {
    let underlineTextField = UnderlineTextField()
    underlineTextField.tintColor = .gray400
    underlineTextField.placeholder = "15자 이내로 입력해주세요"
    underlineTextField.placeholderString = "15자 이내로 입력해주세요"
    underlineTextField.font = .pretendardSemiBold(size: 16.0)
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
  
  func setupView() {
    [underlineTextField].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    underlineTextField.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(4.0)
      $0.trailing.equalToSuperview().offset(-4.0)
      $0.height.equalTo(44.0)
    }
  }
  
  func setupData(item: TitleItem) {
    underlineTextField.text = item.title
  }
  
  func bind() {
    underlineTextField.textPublisher
      .sink { [weak self] text in
        guard let self = self else { return }
        self.viewModel?.title.send(text)
      }
      .store(in: &cancellables)
    
    viewModel?.title
      .sink { [weak self] text in
        guard let self = self else { return }
        self.underlineTextField.text = text
      }
      .store(in: &cancellables)
  }
  
  func configure(with viewModel: TitleCellViewModel) {
    self.viewModel = viewModel
  }
}

extension TitleCell: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let currentText = textField.text,
       let textRange = Range(range, in: currentText) {
      let updatedText = currentText.replacingCharacters(in: textRange, with: string)
      return updatedText.count <= 15
    }
    return true
  }
}
