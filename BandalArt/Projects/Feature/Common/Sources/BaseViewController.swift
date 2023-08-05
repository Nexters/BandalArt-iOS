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
  open var cancellables: Set<AnyCancellable> = []
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    setupAttribute()
    setupView()
    setupConstraints()
    bind()
  }
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  deinit{
    print("\(type(of: self)): \(#function)")
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open func setupAttribute() {}
  open func setupView() {}
  open func setupConstraints() {
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
