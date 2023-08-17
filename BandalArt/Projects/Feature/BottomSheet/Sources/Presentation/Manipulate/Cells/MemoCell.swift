//
//  MainGoalMemoCell.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/02.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Combine
import Components

struct MemoCellViewModel {
  let memo: PassthroughSubject<String?, Never>
}

final class MemoCell: UICollectionViewCell {
  private var cancellables = Set<AnyCancellable>()
  
  lazy var underlineTextField: UnderlineTextField = {
    let underlineTextField = UnderlineTextField()
    underlineTextField.tintColor = .gray400
    underlineTextField.font = .pretendardSemiBold(size: 16.0)
    underlineTextField.setPlaceholder(placeholder: "메모를 입력해주세요", color: .gray400)
    return underlineTextField
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
    underlineTextField.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
  
  func setupData(item: MemoItem) {
    underlineTextField.text = item.memo
  }
  
  func configure(with viewModel: MemoCellViewModel) {
    underlineTextField.textPublisher
      .sink { text in
        guard let text = text else { return }
        viewModel.memo.send(text)
      }
      .store(in: &cancellables)
  }
}

extension MemoCell: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let currentText = textField.text,
       let textRange = Range(range, in: currentText) {
      let updatedText = currentText.replacingCharacters(in: textRange, with: string)
      return updatedText.count <= 15
    }
    return true
  }
}
