//
//  SubGoalAndTaskViewSectionLayoutManager.swift
//  Components
//
//  Created by Sang hun Lee on 2023/08/01.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Util
import Components

struct SubGoalAndTaskViewSectionLayoutManager: SectionLayoutManager {
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch sectionNumber {
      default:
        return makeSection(
          itemType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1),
              heightDimension: .estimated(Size.screenH / 8)
            )
          ),
          groupType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1),
              heightDimension: .estimated(Size.screenH / 8)
            )
          ),
          sectionInset: .init(
            top: 12.0, leading: 4.0, bottom: 12.0, trailing: 4.0
          )
        )
      }
    }
  }
  
  func makeSection(
    itemType: ItemType,
    groupType: GroupType,
    sectionInset: NSDirectionalEdgeInsets = .init(
      top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0
    ),
    interGroupSpacing: CGFloat = 0.0,
    orthogonal: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none,
    containHeader: Bool = true
  ) -> NSCollectionLayoutSection {
    let item = itemType.item
    let groupSize = groupType.groupSize
    
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = sectionInset
    section.orthogonalScrollingBehavior = orthogonal
    section.interGroupSpacing = interGroupSpacing
    
    if containHeader {
      let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25.0))

      let header = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerFooterSize,
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
      )
      section.boundarySupplementaryItems = [header]
    }
    return section
  }
}
