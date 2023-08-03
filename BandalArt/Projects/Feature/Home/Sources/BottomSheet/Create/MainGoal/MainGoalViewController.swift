//
//  MainGoalViewController.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Components

struct MainGoalEmojiTitleItem: Hashable {
  var identifier: UUID
  var emoji: Character
  var title: String
}

struct MainGoalThemeColorItem: Hashable {
  var identifier: UUID
  var color: UIColor
  var selected: Bool
}

struct MainGoalDueDateItem: Hashable {
  var identifier: UUID
  var date: Date
}

struct MainGoalMemoItem: Hashable {
  var identifier: UUID
  var memo: String
}

enum MainGoalSection: Int, CaseIterable {
  case emojiTitle
  case themeColor
  case dueDate
  case memo
  
  var title: String {
    switch self {
    case .emojiTitle:
      return "목표 이름 (필수)"
    case .themeColor:
      return "색상 테마"
    case .dueDate:
      return "마감일 (선택)"
    case .memo:
      return "메모 (선택)"
    }
  }
}

final class MainGoalViewController: BottomSheetController {
  static let sectionHeaderElementKind = "section-header-element-kind"
  
  let mainGoalView = MainGoalView()
  let sectionLayoutFactory = SectionLayoutManagerFactory.shared
  var selectedIndexPath: IndexPath?
  var dataSource: UICollectionViewDiffableDataSource<MainGoalSection, AnyHashable>!
  
  override func loadView() {
    super.loadView()
    view = mainGoalView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    mainGoalView.collectionView.collectionViewLayout = sectionLayoutFactory.createManager(
      type: .mainGoal
    ).createLayout()
    setupDataSource()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    adjustCollectionViewHeight()
  }
  
  func adjustCollectionViewHeight() {
    let contentHeight = mainGoalView.collectionView.contentSize.height
    mainGoalView.collectionView.snp.updateConstraints {
      $0.height.greaterThanOrEqualTo(contentHeight)
    }
  }
  
  func setupDataSource() {
    dataSource = UICollectionViewDiffableDataSource<MainGoalSection, AnyHashable>(
          collectionView: mainGoalView.collectionView
        ) { (collectionView, indexPath, item) -> UICollectionViewCell? in
          switch indexPath.section {
          case 0:
            guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: MainGoalEmojiTitleCell.identifier,
              for: indexPath
            ) as? MainGoalEmojiTitleCell else {
              return UICollectionViewCell()
            }
            guard let item = item as? MainGoalEmojiTitleItem else {
              return UICollectionViewCell()
            }
            cell.setupData(item: item)
            return cell
          case 1:
            guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: MainGoalThemeColorCell.identifier,
              for: indexPath
            ) as? MainGoalThemeColorCell else {
              return UICollectionViewCell()
            }
            guard let item = item as? MainGoalThemeColorItem else {
              return UICollectionViewCell()
            }
            cell.setupData(item: item)
            return cell
          case 2:
            guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: MainGoalDueDateCell.identifier,
              for: indexPath
            ) as? MainGoalDueDateCell else {
              return UICollectionViewCell()
            }
            return cell
          case 3:
            guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: MainGoalMemoCell.identifier,
              for: indexPath
            ) as? MainGoalMemoCell else {
              return UICollectionViewCell()
            }
            return cell
          default:
            return UICollectionViewCell()
          }
        }
  
    var snapshot = NSDiffableDataSourceSnapshot<MainGoalSection, AnyHashable>()
    
    snapshot.appendSections([.emojiTitle])
    snapshot.appendItems([
      MainGoalEmojiTitleItem(identifier: UUID(), emoji: "😎", title: "")
    ], toSection: .emojiTitle)
    
    snapshot.appendSections([.themeColor])
    snapshot.appendItems([
      MainGoalThemeColorItem(identifier: UUID(), color: .mint, selected: false),
      MainGoalThemeColorItem(identifier: UUID(), color: .mint, selected: true),
      MainGoalThemeColorItem(identifier: UUID(), color: .mint, selected: false),
      MainGoalThemeColorItem(identifier: UUID(), color: .mint, selected: false),
      MainGoalThemeColorItem(identifier: UUID(), color: .mint, selected: false),
      MainGoalThemeColorItem(identifier: UUID(), color: .mint, selected: false),
      MainGoalThemeColorItem(identifier: UUID(), color: .mint, selected: false),
      MainGoalThemeColorItem(identifier: UUID(), color: .mint, selected: false),
      MainGoalThemeColorItem(identifier: UUID(), color: .mint, selected: false)
    ], toSection: .themeColor)
    
    snapshot.appendSections([.dueDate])
    snapshot.appendItems([
      MainGoalDueDateItem(identifier: UUID(), date: Date())
    ], toSection: .dueDate)
    
    snapshot.appendSections([.memo])
    snapshot.appendItems([
      MainGoalMemoItem(identifier: UUID(), memo: "")
    ], toSection: .memo)
    
    let headerRegistration = UICollectionView.SupplementaryRegistration
    <BottomSheetSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) {
      (supplementaryView, string, indexPath) in
      let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
      supplementaryView.setupData(header: headerItem.title)
    }
    
    dataSource.supplementaryViewProvider = { (view, kind, index) in
      return self.mainGoalView.collectionView.dequeueConfiguredReusableSupplementary(
        using: headerRegistration, for: index)
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
 
    mainGoalView.collectionView.dataSource = dataSource
  }
}




