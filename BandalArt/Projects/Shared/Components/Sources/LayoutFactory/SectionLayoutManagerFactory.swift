//
//  SectionLayoutManagerFactory.swift
//  Components
//
//  Created by Sang hun Lee on 2023/08/01.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Util

enum SectionLayoutManagerType {
  case home
  case campsiteDetail
  case touristInfoDetail
}

enum ItemType {
  case whole(ratio: CGFloat)
  case specific(size :NSCollectionLayoutSize)
  
  var item: NSCollectionLayoutItem {
    switch self {
    case .whole(let ratio):
      let item = NSCollectionLayoutItem(
        layoutSize: .init(
          widthDimension: .fractionalWidth(1),
          heightDimension: .estimated(Size.screenH * ratio)
        )
      )
      return item
    case .specific(let size):
      let item = NSCollectionLayoutItem(layoutSize: size)
      return item
    }
  }
}

enum GroupFlow {
  case vertical
  case horizontal
}

enum GroupType {
  case whole(ratio: CGFloat)
  case specific(size :NSCollectionLayoutSize)
  
  var groupSize: NSCollectionLayoutSize {
    switch self {
    case .whole(let ratio):
      return NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .estimated(Size.screenH * ratio)
      )
    case .specific(let size):
      return size
    }
  }
}

protocol SectionLayoutManager {
  func createLayout() -> UICollectionViewCompositionalLayout
  func makeSection(
    itemType: ItemType,
    groupType: GroupType,
    sectionInset: NSDirectionalEdgeInsets,
    interGroupSpacing: CGFloat,
    orthogonal: UICollectionLayoutSectionOrthogonalScrollingBehavior,
    containHeader: Bool
  ) -> NSCollectionLayoutSection
}

protocol SectionLayoutManagerCreator {
  func createManager(type: SectionLayoutManagerType) -> SectionLayoutManager
}

class SectionLayoutManagerFactory: SectionLayoutManagerCreator {
  func createManager(type: SectionLayoutManagerType) -> SectionLayoutManager {
    switch type {
    case .home:
      return HomeViewSectionLayoutManager()
    case .campsiteDetail:
      return DetailViewCampsiteSectionLayoutManager()
    case .touristInfoDetail:
      return DetailViewTouristInfoSectionLayoutManager()
    }
  }
}
