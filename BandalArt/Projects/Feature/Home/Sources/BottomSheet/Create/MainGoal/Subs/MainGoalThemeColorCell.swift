//
//  MainGoalThemeColorCell.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/01.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Components
import SnapKit

final class MainGoalThemeColorCell: UICollectionViewCell {
  static let identifier = "MainGoalThemeColorCell"
  
  override func select(_ sender: Any?) {
    super.select(sender)
    circleStrokeView.isHidden = false
  }
  
  lazy var circleStrokeView: CircleView = {
    let view = CircleView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), strokeColor: .mint)
    view.backgroundColor = .clear
    view.isHidden = true
    return view
  }()
  
  lazy var circleView: FilledCircleView = {
    let view = FilledCircleView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), fillColor: .mint)
    view.backgroundColor = .clear
    return view
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
    [circleStrokeView, circleView].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    circleStrokeView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(42.0)
      
    }
    
    circleView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(36.0)
    }
  }
  
  func setupData(item: MainGoalThemeColorItem) {
    circleStrokeView.isHidden = !item.selected
    circleStrokeView.setStrokeColor(color: item.color)
    circleView.setFillColor(color: item.color)
  }
}
