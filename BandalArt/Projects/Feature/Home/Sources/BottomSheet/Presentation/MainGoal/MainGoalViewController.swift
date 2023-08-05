//
//  MainGoalViewController.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Components

struct EmojiTitleItem: Hashable {
  var identifier: UUID
  var emoji: Character
  var title: String
}

struct ThemeColorItem: Hashable {
  var identifier: UUID
  var color: UIColor
  var selected: Bool
}

struct DueDateItem: Hashable {
  var identifier: UUID
  var date: Date
}

struct MemoItem: Hashable {
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

  let mainGoalView: MainGoalView
  let sectionLayoutFactory = SectionLayoutManagerFactory.shared
  var dataSource: UICollectionViewDiffableDataSource<MainGoalSection, AnyHashable>!
  var selectedColor: UIColor = .mint
  
  init(mode: Mode) {
    self.mainGoalView = MainGoalView(mode: mode, frame: .zero)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    view = mainGoalView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupCollectionView()
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
  
  func setupCollectionView() {
    mainGoalView.collectionView.collectionViewLayout = sectionLayoutFactory.createManager(
      type: .mainGoal
    ).createLayout()
    setupDataSource()
    mainGoalView.collectionView.delegate = self
    mainGoalView.collectionView.allowsMultipleSelection = false
  }

  func setupDataSource() {
    dataSource = UICollectionViewDiffableDataSource<MainGoalSection, AnyHashable>(
          collectionView: mainGoalView.collectionView
        ) { (collectionView, indexPath, item) -> UICollectionViewCell? in
          switch indexPath.section {
          case 0:
            guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: EmojiTitleCell.identifier,
              for: indexPath
            ) as? EmojiTitleCell else {
              return UICollectionViewCell()
            }
            guard let item = item as? EmojiTitleItem else {
              return UICollectionViewCell()
            }
            cell.setupData(item: item)
            return cell
          case 1:
            guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: ThemeColorCell.identifier,
              for: indexPath
            ) as? ThemeColorCell else {
              return UICollectionViewCell()
            }
            guard let item = item as? ThemeColorItem else {
              return UICollectionViewCell()
            }
            cell.setupData(item: item)
            cell.updateSelectedState(isSelected: item.selected)
            return cell
          case 2:
            guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: DueDateCell.identifier,
              for: indexPath
            ) as? DueDateCell else {
              return UICollectionViewCell()
            }
            return cell
          case 3:
            guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: MemoCell.identifier,
              for: indexPath
            ) as? MemoCell else {
              return UICollectionViewCell()
            }
            return cell
          default:
            return UICollectionViewCell()
          }
        }

    var snapshot = NSDiffableDataSourceSnapshot<MainGoalSection, AnyHashable>()

    let emojiTitleItem = EmojiTitleItem(identifier: UUID(), emoji: "😎", title: "")
    snapshot.appendSections([.emojiTitle])
    snapshot.appendItems([emojiTitleItem], toSection: .emojiTitle)

    var themeColorItems = [
      ThemeColorItem(identifier: UUID(), color: .mint, selected: false),
      ThemeColorItem(identifier: UUID(), color: .purpleblue, selected: false),
      ThemeColorItem(identifier: UUID(), color: .sky, selected: false),
      ThemeColorItem(identifier: UUID(), color: .grass, selected: false),
      ThemeColorItem(identifier: UUID(), color: .lemon, selected: false),
      ThemeColorItem(identifier: UUID(), color: .yellowred, selected: false)
    ]
  
    if let selectedIndex = themeColorItems.firstIndex(where: { $0.color == .mint }) {
      themeColorItems[selectedIndex].selected = true
      selectedColor = .mint
    }
    
    snapshot.appendSections([.themeColor])
    snapshot.appendItems(themeColorItems, toSection: .themeColor)

    let dueDateItem = DueDateItem(identifier: UUID(), date: Date())
    snapshot.appendSections([.dueDate])
    snapshot.appendItems([dueDateItem], toSection: .dueDate)
    
    let memoItem = MemoItem(identifier: UUID(), memo: "")
    snapshot.appendSections([.memo])
    snapshot.appendItems([memoItem], toSection: .memo)

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
    if let selectedIndex = themeColorItems.firstIndex(where: { $0.color == .mint }) {
      mainGoalView.collectionView.selectItem(
        at: IndexPath(item: selectedIndex, section: 1),
        animated: true,
        scrollPosition: .top
      )
    }
  }
}

extension MainGoalViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch indexPath.section {
    case 1:
      guard let selectedItem = dataSource.itemIdentifier(for: indexPath) as? ThemeColorItem else {
        return
      }
      let snapshot = dataSource.snapshot()
      let currentThemeColorItems = snapshot.itemIdentifiers(inSection: .themeColor)
      
      for themeColorItem in currentThemeColorItems {
        guard var item = themeColorItem as? ThemeColorItem else {
          continue
        }
        item.selected = (item.identifier == selectedItem.identifier)
        if item.selected {
          selectedColor = item.color
        }
      }
      
      dataSource.apply(snapshot, animatingDifferences: true)
    default:
      break
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    switch indexPath.section {
    case 1:
      return true
    default:
      return false
    }
  }
}




