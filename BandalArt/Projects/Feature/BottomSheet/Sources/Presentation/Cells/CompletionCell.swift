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
  
  private lazy var titleLabel = DefaultLabel(
    title: "미달성",
    font: .systemFont(ofSize: 16, weight: .bold),
    textColor: .label
  )
  
  lazy var customSwitch: CustomSwitch = {
    let customSwitch = CustomSwitch()
    customSwitch.translatesAutoresizingMaskIntoConstraints = false
    customSwitch.onTintColor = UIColor.darkGray
    customSwitch.offTintColor = UIColor.lightGray
    customSwitch.cornerRadius = 14
    customSwitch.padding = 3.0
    customSwitch.thumbSize = CGSize(width: 20, height: 20)
    customSwitch.thumbCornerRadius = 10
    customSwitch.thumbTintColor = UIColor.white
    customSwitch.animationDuration = 0.25
    customSwitch.isOn = false
    return customSwitch
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
    [titleLabel, customSwitch].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(4.0)
    }
    
    customSwitch.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-4.0)
      $0.width.equalTo(52.0)
      $0.height.equalTo(28.0)
    }
  }
  
  func setupData(item: Any) {}
}
