//
//  MainGoalViewController.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Components

struct EmojiTitleItem: Identifiable {
  var id: UUID
  var emoji: Character
  var title: String
}

struct ThemeColorItem: Identifiable {
  var id: UUID
  var color: UIColor
}

struct DueDateItem: Identifiable {
  var id: UUID
  var date: Date
}

struct MemoItem: Identifiable {
  var id: UUID
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

public final class MainGoalViewController: BottomSheetController {
  static let sectionHeaderElementKind = "section-header-element-kind"

  let mainGoalView: MainGoalView
  let sectionLayoutFactory = SectionLayoutManagerFactory.shared
  
  var dataSource: UICollectionViewDiffableDataSource<MainGoalSection, UUID>!
  
  public init(mode: Mode) {
    self.mainGoalView = MainGoalView(mode: mode, frame: .zero)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func loadView() {
    super.loadView()
    view = mainGoalView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupCollectionView()
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    adjustCollectionViewHeight()
  }

  func adjustCollectionViewHeight() {
    // TODO: 방어로직 구성, 사이징 변경 시 재구성 필요 
    guard mainGoalView.collectionView.contentSize.height != 0 else { return }
    let contentHeight = mainGoalView.collectionView.contentSize.height
    mainGoalView.collectionView.snp.updateConstraints {
      $0.height.greaterThanOrEqualTo(contentHeight)
    }
  }
  
  func setupCollectionView() {
    mainGoalView.collectionView.collectionViewLayout = sectionLayoutFactory.createManager(
      type: .mainGoal
    ).createLayout()
    setupDataSource()
    mainGoalView.collectionView.delegate = self
    mainGoalView.collectionView.allowsMultipleSelection = false
  }

  func setupDataSource() {
    let emojiTitleCellRegistration = UICollectionView.CellRegistration<EmojiTitleCell, EmojiTitleItem> { cell, indexPath, item in
      cell.setupData(item: item)
    }
    let themeColorCellRegistration = UICollectionView.CellRegistration<ThemeColorCell, ThemeColorItem> { cell, indexPath, item in
      cell.setupData(item: item)
    }
    let dueDateCellRegistration = UICollectionView.CellRegistration<DueDateCell, DueDateItem> { cell, indexPath, item in
      cell.setupData(item: item)
    }
    let memoCellRegistration = UICollectionView.CellRegistration<MemoCell, MemoItem> { cell, indexPath, item in
      cell.setupData(item: item)
    }
    
    let emojiTitleItem = [EmojiTitleItem(id: UUID(), emoji: "😎", title: "")]
    let themeColorItem = [
      ThemeColorItem(id: UUID(), color: .mint),
      ThemeColorItem(id: UUID(), color: .grape),
      ThemeColorItem(id: UUID(), color: .sky),
      ThemeColorItem(id: UUID(), color: .grass),
      ThemeColorItem(id: UUID(), color: .lemon),
      ThemeColorItem(id: UUID(), color: .mandarin)
    ]
    let dueDateItem = [DueDateItem(id: UUID(), date: Date())]
    let memoItem = [MemoItem(id: UUID(), memo: "")]
    
    dataSource = UICollectionViewDiffableDataSource<MainGoalSection, UUID>(
          collectionView: mainGoalView.collectionView
        ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
          switch indexPath.section {
          case 0:
            let item = emojiTitleItem.first(where: { $0.id == identifier })
            return collectionView.dequeueConfiguredReusableCell(
              using: emojiTitleCellRegistration,
              for: indexPath, item: item)
          case 1:
            let item = themeColorItem.first(where: { $0.id == identifier })
            return collectionView.dequeueConfiguredReusableCell(
              using: themeColorCellRegistration,
              for: indexPath, item: item)
          case 2:
            let item = dueDateItem.first(where: { $0.id == identifier })
            return collectionView.dequeueConfiguredReusableCell(
              using: dueDateCellRegistration,
              for: indexPath, item: item)
          case 3:
            let item = memoItem.first(where: { $0.id == identifier })
            return collectionView.dequeueConfiguredReusableCell(
              using: memoCellRegistration,
              for: indexPath, item: item)
          default:
            return UICollectionViewCell()
          }
        }

    var snapshot = NSDiffableDataSourceSnapshot<MainGoalSection, UUID>()
    
    snapshot.appendSections([.emojiTitle])
    snapshot.appendItems(emojiTitleItem.map{ $0.id }, toSection: .emojiTitle)

    snapshot.appendSections([.themeColor])
    snapshot.appendItems(themeColorItem.map{ $0.id }, toSection: .themeColor)

    snapshot.appendSections([.dueDate])
    snapshot.appendItems(dueDateItem.map{ $0.id }, toSection: .dueDate)
    
    snapshot.appendSections([.memo])
    snapshot.appendItems(memoItem.map{ $0.id }, toSection: .memo)

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
    mainGoalView.collectionView.selectItem(
      at: IndexPath(item: 0, section: 1),
      animated: true,
      scrollPosition: .top
    )
  }
}

extension MainGoalViewController: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    switch indexPath.section {
    case 1:
      return true
    default:
      return false
    }
  }
}




