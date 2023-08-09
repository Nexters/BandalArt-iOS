//
//  EmojiPopupView.swift
//  BottomSheetFeature
//
//  Created by Sang hun Lee on 2023/08/09.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Components

final class EmojiPopupView: UIView {
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
    fatalError("EmojiPopupView fatal error")
  }
  
  private func setupView() {
    [collectionView].forEach {
      addSubview($0)
    }
  }
  
  private func setupConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
  }
}
