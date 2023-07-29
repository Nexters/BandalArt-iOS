//
//  BaseViewController.swift
//  CommonFeature
//
//  Created by Sang hun Lee on 2023/07/29.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Network
import Util
import Combine
import SnapKit

open class BaseViewController: UIViewController {
  private let activityIndicator = UIActivityIndicatorView(style: .medium)
  
  public let bounds = UIScreen.main.bounds
  open var cancellables: Set<AnyCancellable> = []
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    bind()
  }
  
  public init() {
    super.init(nibName: nil, bundle: nil)
    setupAttribute()
    setupView()
    setupConstraints()
    configureVC()
    configureNavigation()
    configureIndicator()
  }
  
  deinit{
    print("\(type(of: self)): \(#function)")
  }
  
  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    setupAttribute()
    setupView()
    setupConstraints()
    configureVC()
    configureNavigation()
    configureIndicator()
  }
  
  open func setupAttribute() {}
  open func setupView() {}
  open func setupConstraints() {}
  open func configureVC() {}
  open func configureNavigation() {}
  private func configureIndicator() {
    view.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(50)
    }
  }
  
  open func bind() {}
  open func startIndicator() {
    activityIndicator.startAnimating()
  }
  open func stopIndicator() {
    activityIndicator.stopAnimating()
  }
}
