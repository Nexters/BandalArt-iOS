//
//  CustomAlertViewController.swift
//  Components
//
//  Created by Sang hun Lee on 2023/08/15.
//  Copyright © 2023 otani. All rights reserved.
//

import UIKit
import SnapKit

public final class PopUpViewController: UIViewController {
  private weak var iconImage: UIImage?
  private var titleText: String?
  private var messageText: String?
  private weak var attributedMessageText: NSAttributedString?
  private weak var contentView: UIView?
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 12.0
    view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    return view
  }()
  
  private lazy var containerStackView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.spacing = 12.0
    view.alignment = .center
    
    return view
  }()
  
  private lazy var buttonStackView: UIStackView = {
    let view = UIStackView()
    view.spacing = 14.0
    view.distribution = .fillEqually
    
    return view
  }()
  
  private lazy var messageStackView: UIStackView = {
    let view = UIStackView()
    view.spacing = 5.0
    view.distribution = .fill
    
    return view
  }()
  
  private lazy var iconImageView: UIImageView? = {
    let imageView = UIImageView()
    imageView.image = iconImage
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints {
      $0.width.height.equalTo(48.0)
    }
    return imageView
  }()
  
  private lazy var titleLabel: UILabel? = {
    let label = UILabel()
    label.text = titleText
    label.textAlignment = .center
    label.font = .pretendardBold(size: 20.0)
    label.numberOfLines = 0
    label.textColor = .gray900
    
    return label
  }()
  
  private lazy var messageIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "circle.exclamation")
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints {
      $0.width.height.equalTo(16.0)
    }
    return imageView
  }()
  
  private lazy var messageLabel: UILabel? = {
    guard messageText != nil || attributedMessageText != nil else { return nil }
    
    let label = UILabel()
    label.text = messageText
    label.textAlignment = .center
    label.font = .pretendardMedium(size: 14.0)
    label.textColor = .gray400
    label.numberOfLines = 0
    
    if let attributedMessageText = attributedMessageText {
      label.attributedText = attributedMessageText
    }
    
    return label
  }()
  
  convenience init(iconImage: UIImage? = UIImage(named: "trash"),
                   titleText: String? = nil,
                   messageText: String? = nil,
                   attributedMessageText: NSAttributedString? = nil) {
    self.init()
    self.iconImage = iconImage
    self.titleText = titleText
    self.messageText = messageText
    self.attributedMessageText = attributedMessageText
    /// present 시 fullScreen (화면을 덮도록 설정) -> 설정 안하면 pageSheet 형태 (위가 좀 남아서 밑에 깔린 뷰가 보이는 형태)
    modalPresentationStyle = .overFullScreen
  }
  
  convenience init(contentView: UIView) {
    self.init()
    
    self.contentView = contentView
    modalPresentationStyle = .overFullScreen
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
      self?.containerView.transform = .identity
      self?.containerView.isHidden = false
    }
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
      self?.containerView.transform = .identity
      self?.containerView.isHidden = true
    }
  }
  
  deinit {
    print("디이닛 오케잉?")
  }
  
  public func addActionToButton(title: String? = nil,
                                titleColor: UIColor = .white,
                                backgroundColor: UIColor = .gray900,
                                completion: @escaping () -> Void) {
    guard let title = title else { return }

    let button = UIButton()
    button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
    
    // enable
    button.setTitle(title, for: .normal)
    button.setTitleColor(titleColor, for: .normal)
    button.setBackgroundImage(backgroundColor.image(), for: .normal)
    
    // disable
    button.setTitleColor(.gray900, for: .disabled)
    button.setBackgroundImage(UIColor.gray200.image(), for: .disabled)
    
    // layer
    button.layer.cornerRadius = 28.0
    button.layer.masksToBounds = true
    
    button.addAction(for: .touchUpInside) { _ in
      completion()
    }
    
    buttonStackView.addArrangedSubview(button)
  }
  
  private func setupView() {
    view.addSubview(containerView)
    containerView.addSubview(containerStackView)
    view.backgroundColor = .black.withAlphaComponent(0.2)
    
    view.addSubview(containerStackView)
    
    if let contentView = contentView {
      containerStackView.addSubview(contentView)
    } else {
      if let iconImageView = iconImageView {
        containerStackView.addArrangedSubview(iconImageView)
      }
      
      if let titleLabel = titleLabel {
        containerStackView.addArrangedSubview(titleLabel)
      }
      
      if let messageLabel = messageLabel {
        messageStackView.addArrangedSubview(messageIcon)
        messageStackView.addArrangedSubview(messageLabel)
        containerStackView.addArrangedSubview(messageStackView)
      }
    }
    
    if let lastView = containerStackView.subviews.last {
      containerStackView.setCustomSpacing(24.0, after: lastView)
    }
    
    containerStackView.addArrangedSubview(buttonStackView)
  }
  
  private func setupConstraints() {
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerStackView.translatesAutoresizingMaskIntoConstraints = false
    buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 32),
      containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -32),
      
      containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
      containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
      containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
      containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
      
      buttonStackView.heightAnchor.constraint(equalToConstant: 56),
      buttonStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor)
    ])
  }
}

