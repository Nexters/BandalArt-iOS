//
//  BottomSheetHeader.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/02.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Components

final class BottomSheetSectionHeader: UICollectionReusableView {
  static let identifier = "BottomSheetSectionHeader"
  
  private lazy var titleLabel = DefaultLabel(font: .systemFont(ofSize: 12, weight: .bold), textColor: .label)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    [titleLabel].forEach {
      self.addSubview($0)
    }
  }
  
  func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
    }
  }
  
  func setupData(header: String) {
    self.titleLabel.text = header
  }
}
