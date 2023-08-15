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

struct TtleCellViewModel {
  let title: CurrentValueSubject<String, Never>
}

final class TitleCell: UICollectionViewCell {
  static let identifier = "TitleCell"
  private var cancellables = Set<AnyCancellable>()
  
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
  
  func configure(with viewModel: TtleCellViewModel) {
    underlineTextField.textPublisher
      .sink { text in
        guard let text = text else { return }
        viewModel.title.send(text)
      }
      .store(in: &cancellables)
    
    viewModel.title
      .sink { [weak self] text in
        self?.underlineTextField.text = text
      }
      .store(in: &cancellables)
  }
}
