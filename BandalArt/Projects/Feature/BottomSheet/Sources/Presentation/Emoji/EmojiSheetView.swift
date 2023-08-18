//
//  EmojiSelectionView.swift
//  BottomSheetFeature
//
//  Created by Sang hun Lee on 2023/08/09.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Components

final class EmojiSheetView: UIView {
  
  lazy var completionButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.gray900, for: .normal)
    button.titleLabel?.font = .pretendardBold(size: 16.0)
    button.setTitle("완료", for: .normal)
    return button
  }()
  
  lazy var collectionView: UICollectionView = {
    let collection = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    return collection
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("EmojiSelectionView fatal error")
  }
  
  private func setupView() {
    [completionButton, collectionView].forEach {
      addSubview($0)
    }
  }
  
  private func setupConstraints() {
    completionButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16.0)
      $0.trailing.equalToSuperview().offset(-20.0)
      $0.width.equalTo(28.0)
      $0.height.equalTo(22.0)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(completionButton.snp.bottom)
      $0.leading.equalTo(safeAreaLayoutGuide)
      $0.trailing.equalTo(safeAreaLayoutGuide)
      $0.bottom.equalTo(safeAreaLayoutGuide)
      $0.height.greaterThanOrEqualTo(280.0)
    }
  }
}
