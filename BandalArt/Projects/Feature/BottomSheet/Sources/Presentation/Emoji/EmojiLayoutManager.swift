//
//  EmojiLayoutManager.swift
//  BottomSheetFeature
//
//  Created by Sang hun Lee on 2023/08/09.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Util
import Components

struct EmojiLayoutManager: SectionLayoutManager {
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch sectionNumber {
      default:
        return makeSection(
          itemType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1.0 / 6.0),
              heightDimension: .fractionalHeight(1.0)
            ),
            inset: NSDirectionalEdgeInsets(
              top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0
            )
          ),
          groupType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .fractionalWidth(1.0 / 6.0)
            )
          ),
          containHeader: false
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
    
    let group = NSCollectionLayoutGroup.horizontal(
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
