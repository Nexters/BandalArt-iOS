//
//  ManipulateView.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Components

final class ManipulateView: UIView {
  let mode: Mode
  let bandalArtCellType: BandalArtCellType
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "메인목표 입력"
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 16.0, weight: .bold)
    label.textColor = .label
    return label
  }()

  lazy var closeButton: UIButton = {
    let button = UIButton()
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.tintColor = .gray900
    return button
  }()
  
  lazy var collectionView: UICollectionView = {
    let collection = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    return collection
  }()

  lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.setTitle("삭제", for: .normal)
    button.setTitleColor(.gray900, for: .normal)
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
  
  lazy var buttonContainerView: UIStackView = {
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

  init(mode: Mode, bandalArtCellType: BandalArtCellType, frame: CGRect) {
    self.mode = mode
    self.bandalArtCellType = bandalArtCellType
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("ManipulateView fatal error")
  }

  private func setupView() {
    [titleLabel, closeButton, collectionView, buttonContainerView].forEach {
      addSubview($0)
      switch bandalArtCellType {
      case .mainGoal:
        switch mode {
        case .create:
          titleLabel.text = "메인목표 입력"
          deleteButton.isHidden = true
        case .update:
          titleLabel.text = "메인목표 수정"
          deleteButton.isHidden = false
        }
      case .subGoal:
        switch mode {
        case .create:
          titleLabel.text = "서브목표 입력"
          deleteButton.isHidden = true
        case .update:
          titleLabel.text = "서브목표 수정"
          deleteButton.isHidden = false
        }
      case .task:
        switch mode {
        case .create:
          titleLabel.text = "태스크 입력"
          deleteButton.isHidden = true
        case .update:
          titleLabel.text = "태스크 수정"
          deleteButton.isHidden = false
        }
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
    
    closeButton.snp.makeConstraints {
      $0.centerY.equalTo(titleLabel)
      $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16.0)
      $0.width.height.equalTo(44.0)
    }

    collectionView.snp.makeConstraints {
      $0.leading.equalTo(safeAreaLayoutGuide).offset(16.0)
      $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16.0)
      $0.bottom.equalTo(completionButton.snp.top).offset(-16.0)
      $0.height.greaterThanOrEqualTo(364.0)
    }

    buttonContainerView.snp.makeConstraints {
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
