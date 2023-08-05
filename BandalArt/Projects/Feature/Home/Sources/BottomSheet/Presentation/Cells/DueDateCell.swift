//
//  MainGoalDueDateCell.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/02.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Components

final class DueDateCell: UICollectionViewCell {
  static let identifier = "DueDateCell"
  
  lazy var underlineTextField: UnderlineTextField = {
    let underlineTextField = UnderlineTextField()
    underlineTextField.tintColor = .gray400
    underlineTextField.placeholder = "마감일을 선택해주세요"
    underlineTextField.placeholderString = "마감일을 선택해주세요"
    return underlineTextField
  }()
  
  lazy var datePickerButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "chevron.right"), for: .normal)
    return button
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
    [underlineTextField, datePickerButton].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    underlineTextField.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(4.0)
      $0.trailing.equalToSuperview().offset(-4.0)
    }
    
    datePickerButton.snp.makeConstraints {
      $0.width.height.equalTo(24.0)
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
  }
  
  func setupData(item: DueDateItem) {
    
  }
}
