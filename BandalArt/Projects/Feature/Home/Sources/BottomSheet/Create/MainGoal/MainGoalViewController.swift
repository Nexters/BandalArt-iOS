//
//  MainGoalViewController.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit

final class MainGoalViewController: BottomSheetController {
  let mainGoalView = MainGoalView()
  
  override func loadView() {
    super.loadView()
    view = mainGoalView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainGoalView.collectionView.delegate = self
    mainGoalView.collectionView.dataSource = self
    view.backgroundColor = .systemBackground
    title = "메인목표 입력"
  }
  
  
}

extension MainGoalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainGoalEmojiTitleCell.identifier, for: indexPath) as? MainGoalEmojiTitleCell else {
      return UICollectionViewCell()
    }
    
    return cell
  }
  
  
}
