//
//  CompletionCell.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Components

final class CompletionCell: UICollectionViewCell {
  static let identifier = "CompletionCell"
  
  private lazy var titleLabel = DefaultLabel(font: .systemFont(ofSize: 16, weight: .bold), textColor: .label)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {}
  
  func setupConstraints() {}
  
  func setupData(item: Any) {}
}
