//
//  BaseTableViewCell.swift
//  CommonFeature
//
//  Created by Sang hun Lee on 2023/07/29.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit

open class BaseTableViewCell<T>: UITableViewCell {
  public let bound = UIScreen.main.bounds
  public var model: T? {
    didSet { if let model = model { bind(model) } }
  }
  
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
    configureCell()
  }
  
  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
    setupConstraints()
    configureCell()
  }
  
  open func setupView() {}
  open func setupConstraints() {}
  open func configureCell() {}
  open func bind(_ model: T) {}
}
