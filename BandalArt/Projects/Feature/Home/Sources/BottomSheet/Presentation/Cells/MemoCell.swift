//
//  MainGoalMemoCell.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/02.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Components

final class MemoCell: UICollectionViewCell {
  static let identifier = "MemoCell"
  
  lazy var underlineTextField: UnderlineTextField = {
    let underlineTextField = UnderlineTextField()
    underlineTextField.tintColor = .gray400
    underlineTextField.placeholder = "메모를 입력해주세요"
    underlineTextField.placeholderString = "메모를 입력해주세요"
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
    }
  }
  
  func setupData(item: MemoItem) {
    
  }
}
