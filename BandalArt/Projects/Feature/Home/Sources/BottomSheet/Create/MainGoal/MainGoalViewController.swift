//
//  MainGoalViewController.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Components

final class MainGoalViewController: BottomSheetController {
  let mainGoalView = MainGoalView()
  let sectionLayoutFactory = SectionLayoutManagerFactory.shared
  
  override func loadView() {
    super.loadView()
    view = mainGoalView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainGoalView.collectionView.delegate = self
    mainGoalView.collectionView.dataSource = self
    view.backgroundColor = .systemBackground
    mainGoalView.collectionView.collectionViewLayout = sectionLayoutFactory.createManager(
      type: .mainGoal
    ).createLayout()
  }
}

extension MainGoalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 1:
      return 0
    default:
      return 1
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.section {
    case 1:
      return UICollectionViewCell()
    default:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainGoalEmojiTitleCell.identifier, for: indexPath) as? MainGoalEmojiTitleCell else {
        return UICollectionViewCell()
      }
      
      return cell
    }
  }
  
  
}
