//
//  MainGoalView.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit

final class MainGoalView: UIView {
  lazy var collectionView: UICollectionView = {
    let collection = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    collection.register(
      MainGoalEmojiTitleCell.self,
      forCellWithReuseIdentifier: MainGoalEmojiTitleCell.identifier
    )
    return collection
  }()
  
  lazy var completionButton: UIButton = {
    let button = UIButton()
    button.setTitle("완료", for: .normal)
    button.setTitleColor(.gray400, for: .normal)
    button.backgroundColor = .gray200
    button.layer.cornerRadius = 28
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    return button
  }()
  
  lazy var containerView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.addArrangedSubview(collectionView)
    stackView.addArrangedSubview(completionButton)
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 8.0
    stackView.contentMode = .scaleToFill
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("MainView fatal error")
  }
  
  private func setupView() {
    [containerView].forEach {
      addSubview($0)
    }
    
  }
  
  private func setupConstraints() {
    containerView.snp.makeConstraints {
      $0.top.bottom.equalTo(self.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().offset(16.0)
      $0.trailing.equalToSuperview().offset(-16.0)
    }
    
    completionButton.snp.makeConstraints {
      $0.height.equalTo(56.0)
      $0.width.equalToSuperview()
    }
  }
}
