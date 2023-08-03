//
//  MainGoalView.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Components

// TODO: update / create enum 구분

final class MainGoalView: UIView {
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "메인목표 입력"
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 16.0, weight: .bold)
    label.textColor = .label
    return label
  }()
  
  lazy var collectionView: UICollectionView = {
    let collection = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    collection.register(
      MainGoalEmojiTitleCell.self,
      forCellWithReuseIdentifier: MainGoalEmojiTitleCell.identifier
    )
    collection.register(
      MainGoalThemeColorCell.self,
      forCellWithReuseIdentifier: MainGoalThemeColorCell.identifier
    )
    collection.register(
      MainGoalDueDateCell.self,
      forCellWithReuseIdentifier: MainGoalDueDateCell.identifier
    )
    collection.register(
      MainGoalMemoCell.self,
      forCellWithReuseIdentifier: MainGoalMemoCell.identifier
    )
//    collection.register(
//      BottomSheetSectionHeader.self,
//      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//      withReuseIdentifier: BottomSheetSectionHeader.identifier
//    )
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
    [titleLabel, collectionView, completionButton].forEach {
      addSubview($0)
    }
    
  }
  
  private func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.leading.equalTo(safeAreaLayoutGuide).offset(16.0)
      $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16.0)
      $0.bottom.equalTo(collectionView.snp.top).offset(-16.0)
    }
    
//    containerView.snp.makeConstraints {
//      $0.top.bottom.equalTo(self.safeAreaLayoutGuide)
//      $0.leading.equalToSuperview().offset(16.0)
//      $0.trailing.equalToSuperview().offset(-16.0)
//    }
//
    collectionView.snp.makeConstraints {
      $0.leading.equalTo(safeAreaLayoutGuide).offset(16.0)
      $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16.0)
      $0.bottom.equalTo(completionButton.snp.top).offset(-16.0)
      $0.height.greaterThanOrEqualTo(364.0)
    }
    
    completionButton.snp.makeConstraints {
      $0.height.equalTo(56.0)
      $0.leading.equalTo(safeAreaInsets).offset(16.0)
      $0.trailing.equalTo(safeAreaInsets).offset(-16.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16.0)
    }
  }
}
