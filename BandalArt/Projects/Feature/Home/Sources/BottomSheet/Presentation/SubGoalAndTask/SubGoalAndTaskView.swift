//
//  SubGoalAndTaskView.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Components

final class SubGoalAndTaskView: UIView {
  let mode: Mode
  
  let type:
  
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
      DueDateCell.self,
      forCellWithReuseIdentifier: DueDateCell.identifier
    )
    collection.register(
      MemoCell.self,
      forCellWithReuseIdentifier: MemoCell.identifier
    )

    return collection
  }()
  
  lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.setTitle("삭제", for: .normal)
    button.setTitleColor(.gray400, for: .normal)
    button.backgroundColor = .gray200
    button.layer.cornerRadius = 28
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    return button
  }()
  
  lazy var completionButton: UIButton = {
    let button = UIButton()
    button.setTitle("완료", for: .normal)
    button.setTitleColor(.gray400, for: .disabled)
    button.setBackgroundImage(UIImage(color: .gray200), for: .disabled)
    button.setTitleColor(.white, for: .normal)
    button.setBackgroundImage(UIImage(color: .gray900), for: .normal)
    button.layer.cornerRadius = 28
    button.clipsToBounds = true
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    button.isEnabled = false
    return button
  }()
  
  lazy var ButtonContainerView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.addArrangedSubview(deleteButton)
    stackView.addArrangedSubview(completionButton)
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.spacing = 8.0
    stackView.contentMode = .scaleToFill
    return stackView
  }()
  
  init(mode: Mode, frame: CGRect) {
    self.mode = mode
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("SubGoalAndTaskView fatal error")
  }
  
  private func setupView() {
    [titleLabel, collectionView, ButtonContainerView].forEach {
      addSubview($0)
      
      switch mode {
      case .create:
        titleLabel.text = "메인목표 입력"
        deleteButton.isHidden = true
      case .update:
        titleLabel.text = "메인목표 수정"
        deleteButton.isHidden = false
      }
    }
  }

  private func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.leading.equalTo(safeAreaLayoutGuide).offset(16.0)
      $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16.0)
      $0.bottom.equalTo(collectionView.snp.top).offset(-16.0)
    }

    collectionView.snp.makeConstraints {
      $0.leading.equalTo(safeAreaLayoutGuide).offset(16.0)
      $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16.0)
      $0.bottom.equalTo(completionButton.snp.top).offset(-16.0)
      $0.height.greaterThanOrEqualTo(364.0)
    }

    ButtonContainerView.snp.makeConstraints {
      $0.height.equalTo(56.0)
      $0.leading.equalTo(safeAreaInsets).offset(16.0)
      $0.trailing.equalTo(safeAreaInsets).offset(-16.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16.0)
    }
    
    deleteButton.snp.makeConstraints {
      $0.height.equalTo(56.0)
    }
    
    completionButton.snp.makeConstraints {
      $0.height.equalTo(56.0)
    }
  }
}
