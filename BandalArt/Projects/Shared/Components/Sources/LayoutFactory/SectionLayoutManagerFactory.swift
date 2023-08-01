//
//  SectionLayoutManagerFactory.swift
//  Components
//
//  Created by Sang hun Lee on 2023/08/01.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Util

public enum SectionLayoutManagerType {
  case mainGoal
  case subGoalAndTask
//  case emoji
//  case madalArtList
}

public enum ItemType {
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

public enum GroupFlow {
  case vertical
  case horizontal
}

public enum GroupType {
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

public protocol SectionLayoutManager {
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

public protocol SectionLayoutManagerCreator {
  func createManager(type: SectionLayoutManagerType) -> SectionLayoutManager
}

public final class SectionLayoutManagerFactory: SectionLayoutManagerCreator {
  public static let shared = SectionLayoutManagerFactory()
  
  public func createManager(type: SectionLayoutManagerType) -> SectionLayoutManager {
    switch type {
    case .mainGoal:
      return MainGoalViewSectionLayoutManager()
    case .subGoalAndTask:
      return SubGoalAndTaskViewSectionLayoutManager()
//    case .emoji:
//      <#code#>
//    case .madalArtList:
//      <#code#>
    }
  }
}
