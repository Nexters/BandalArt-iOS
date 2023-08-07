//
//  MainGoalViewController.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Components

protocol DatePickerCallDelegate: AnyObject {
  func datePickerButtonTapped(in cell: DueDateCell, isOpen: Bool)
}

protocol EmojiSelectorDelegate: AnyObject {
  func emojiViewTapped(in cell: EmojiTitleCell)
}

public final class MainGoalViewController: BottomSheetController {
  let mode: Mode
  let bandalArtCellType: BandalArtCellType
  let mainGoalView: MainGoalView
  let sectionLayoutFactory = SectionLayoutManagerFactory.shared
  
  var mainDataSource: UICollectionViewDiffableDataSource<MainGoalSection, UUID>!
  var subGoalAndTaskCreateDataSource:  UICollectionViewDiffableDataSource<SubGoalAndTaskCreateSection, UUID>!
  var taskUpdateDataSource: UICollectionViewDiffableDataSource<TaskUpdateSection, UUID>!

  
  public init(mode: Mode, bandalArtCellType: BandalArtCellType) {
    self.mainGoalView = MainGoalView(
      mode: mode,
      bandalArtCellType: bandalArtCellType,
      frame: .zero
    )
    self.mode = mode
    self.bandalArtCellType = bandalArtCellType
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
    // guard mainGoalView.collectionView.contentSize.height != 0 else { return }
    let contentHeight = mainGoalView.collectionView.contentSize.height
    mainGoalView.collectionView.snp.updateConstraints {
      $0.height.greaterThanOrEqualTo(contentHeight)
    }
  }
  
  func setupCollectionView() {
    switch bandalArtCellType {
    case .main:
      mainGoalView.collectionView.collectionViewLayout = sectionLayoutFactory.createManager(
        type: .mainGoal
      ).createLayout()
    default:
      mainGoalView.collectionView.collectionViewLayout = sectionLayoutFactory.createManager(
        type: .subGoalAndTask
      ).createLayout()
    }
    setupDataSource()
    mainGoalView.collectionView.delegate = self
    mainGoalView.collectionView.allowsMultipleSelection = false
  }

  func setupDataSource() {
    let emojiTitleItem = [EmojiTitleItem(id: UUID(), emoji: "😎", title: "")]
    let themeColorItem = [
      ThemeColorItem(id: UUID(), color: .mint),
      ThemeColorItem(id: UUID(), color: .grape),
      ThemeColorItem(id: UUID(), color: .sky),
      ThemeColorItem(id: UUID(), color: .grass),
      ThemeColorItem(id: UUID(), color: .lemon),
      ThemeColorItem(id: UUID(), color: .mandarin)
    ]
    let titleItem = [TitleItem(id: UUID(), title: "")]
    let dueDateItem = [DueDateItem(id: UUID(), date: Date())]
    let memoItem = [MemoItem(id: UUID(), memo: "")]
    let completionItem = [CompletionItem(id: UUID(), isCompleted: false)]
    
    let emojiTitleCellRegistration = UICollectionView.CellRegistration<EmojiTitleCell, EmojiTitleItem> { cell, indexPath, item in
      cell.setupData(item: item)
      cell.delegate = self
    }
    let titleCellRegistration = UICollectionView.CellRegistration<TitleCell, TitleItem> { cell, indexPath, item in
      cell.setupData(item: item)
    }
    let themeColorCellRegistration = UICollectionView.CellRegistration<ThemeColorCell, ThemeColorItem> { cell, indexPath, item in
      cell.setupData(item: item)
    }
    let dueDateCellRegistration = UICollectionView.CellRegistration<DueDateCell, DueDateItem> { cell, indexPath, item in
      cell.setupData(item: item)
      cell.delegate = self
    }
    let memoCellRegistration = UICollectionView.CellRegistration<MemoCell, MemoItem> { cell, indexPath, item in
      cell.setupData(item: item)
    }
    let completionCellRegistration = UICollectionView.CellRegistration<CompletionCell, CompletionItem> { cell, indexPath, item in
      cell.setupData(item: item)
    }
    
    switch bandalArtCellType {
    case .main:
      mainDataSource = UICollectionViewDiffableDataSource<MainGoalSection, UUID>(
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
        let headerItem = self.mainDataSource.snapshot().sectionIdentifiers[indexPath.section]
        supplementaryView.setupData(header: headerItem.title)
      }

      mainDataSource.supplementaryViewProvider = { (view, kind, index) in
        return self.mainGoalView.collectionView.dequeueConfiguredReusableSupplementary(
          using: headerRegistration, for: index)
      }
      
      mainDataSource.apply(snapshot, animatingDifferences: false)
    case .subGoal:
      subGoalAndTaskCreateDataSource = UICollectionViewDiffableDataSource<SubGoalAndTaskCreateSection, UUID>(
            collectionView: mainGoalView.collectionView
          ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            switch indexPath.section {
            case 0:
              let item = titleItem.first(where: { $0.id == identifier })
              return collectionView.dequeueConfiguredReusableCell(
                using: titleCellRegistration,
                for: indexPath, item: item)
            case 1:
              let item = dueDateItem.first(where: { $0.id == identifier })
              return collectionView.dequeueConfiguredReusableCell(
                using: dueDateCellRegistration,
                for: indexPath, item: item)
            case 2:
              let item = memoItem.first(where: { $0.id == identifier })
              return collectionView.dequeueConfiguredReusableCell(
                using: memoCellRegistration,
                for: indexPath, item: item)
            default:
              return UICollectionViewCell()
            }
          }

      var snapshot = NSDiffableDataSourceSnapshot<SubGoalAndTaskCreateSection, UUID>()
      
      snapshot.appendSections([.title])
      snapshot.appendItems(titleItem.map{ $0.id }, toSection: .title)

      snapshot.appendSections([.dueDate])
      snapshot.appendItems(dueDateItem.map{ $0.id }, toSection: .dueDate)
      
      snapshot.appendSections([.memo])
      snapshot.appendItems(memoItem.map{ $0.id }, toSection: .memo)
      
      let headerRegistration = UICollectionView.SupplementaryRegistration
      <BottomSheetSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) {
        (supplementaryView, string, indexPath) in
        let headerItem = self.subGoalAndTaskCreateDataSource.snapshot().sectionIdentifiers[indexPath.section]
        supplementaryView.setupData(header: headerItem.title)
      }

      subGoalAndTaskCreateDataSource.supplementaryViewProvider = { (view, kind, index) in
        return self.mainGoalView.collectionView.dequeueConfiguredReusableSupplementary(
          using: headerRegistration, for: index)
      }
      
      subGoalAndTaskCreateDataSource.apply(snapshot, animatingDifferences: false)
    case .task:
      switch mode {
      case .create:
        subGoalAndTaskCreateDataSource = UICollectionViewDiffableDataSource<SubGoalAndTaskCreateSection, UUID>(
              collectionView: mainGoalView.collectionView
            ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
              switch indexPath.section {
              case 0:
                let item = titleItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: titleCellRegistration,
                  for: indexPath, item: item)
              case 1:
                let item = dueDateItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: dueDateCellRegistration,
                  for: indexPath, item: item)
              case 2:
                let item = memoItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: memoCellRegistration,
                  for: indexPath, item: item)
              default:
                return UICollectionViewCell()
              }
            }

        var snapshot = NSDiffableDataSourceSnapshot<SubGoalAndTaskCreateSection, UUID>()
        
        snapshot.appendSections([.title])
        snapshot.appendItems(titleItem.map{ $0.id }, toSection: .title)

        snapshot.appendSections([.dueDate])
        snapshot.appendItems(dueDateItem.map{ $0.id }, toSection: .dueDate)
        
        snapshot.appendSections([.memo])
        snapshot.appendItems(memoItem.map{ $0.id }, toSection: .memo)
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <BottomSheetSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) {
          (supplementaryView, string, indexPath) in
          let headerItem = self.subGoalAndTaskCreateDataSource.snapshot().sectionIdentifiers[indexPath.section]
          supplementaryView.setupData(header: headerItem.title)
        }

        subGoalAndTaskCreateDataSource.supplementaryViewProvider = { (view, kind, index) in
          return self.mainGoalView.collectionView.dequeueConfiguredReusableSupplementary(
            using: headerRegistration, for: index)
        }
        
        subGoalAndTaskCreateDataSource.apply(snapshot, animatingDifferences: false)
      case .update:
        taskUpdateDataSource = UICollectionViewDiffableDataSource<TaskUpdateSection, UUID>(
              collectionView: mainGoalView.collectionView
            ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
              switch indexPath.section {
              case 0:
                let item = titleItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: titleCellRegistration,
                  for: indexPath, item: item)
              case 1:
                let item = dueDateItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: dueDateCellRegistration,
                  for: indexPath, item: item)
              case 2:
                let item = memoItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: memoCellRegistration,
                  for: indexPath, item: item)
              case 3:
                let item = completionItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: completionCellRegistration,
                  for: indexPath, item: item)
              default:
                return UICollectionViewCell()
              }
            }

        var snapshot = NSDiffableDataSourceSnapshot<TaskUpdateSection, UUID>()
        
        snapshot.appendSections([.title])
        snapshot.appendItems(titleItem.map{ $0.id }, toSection: .title)

        snapshot.appendSections([.dueDate])
        snapshot.appendItems(dueDateItem.map{ $0.id }, toSection: .dueDate)
        
        snapshot.appendSections([.memo])
        snapshot.appendItems(memoItem.map{ $0.id }, toSection: .memo)
        
        snapshot.appendSections([.completion])
        snapshot.appendItems(completionItem.map{ $0.id }, toSection: .completion)
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <BottomSheetSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) {
          (supplementaryView, string, indexPath) in
          let headerItem = self.taskUpdateDataSource.snapshot().sectionIdentifiers[indexPath.section]
          supplementaryView.setupData(header: headerItem.title)
        }

        taskUpdateDataSource.supplementaryViewProvider = { (view, kind, index) in
          return self.mainGoalView.collectionView.dequeueConfiguredReusableSupplementary(
            using: headerRegistration, for: index)
        }
        
        taskUpdateDataSource.apply(snapshot, animatingDifferences: false)
      }
    }

    switch bandalArtCellType {
    case .main:
      mainGoalView.collectionView.dataSource = mainDataSource
      mainGoalView.collectionView.selectItem(
        at: IndexPath(item: 0, section: 1),
        animated: true,
        scrollPosition: .top
      )
    case .subGoal:
      mainGoalView.collectionView.dataSource = subGoalAndTaskCreateDataSource
    case .task:
      switch mode {
      case .create:
        mainGoalView.collectionView.dataSource = subGoalAndTaskCreateDataSource
      case .update:
        mainGoalView.collectionView.dataSource = taskUpdateDataSource
      }
    }
  }
}

extension MainGoalViewController: UICollectionViewDelegate, DatePickerCallDelegate, EmojiSelectorDelegate {
  func datePickerButtonTapped(in cell: DueDateCell, isOpen: Bool) {
    switch bandalArtCellType {
    case .main:
      UIView.transition(with: mainGoalView.collectionView, duration: 0.3, options: .curveEaseInOut, animations: {
        var snapshot = self.mainDataSource.snapshot()
        if isOpen { snapshot.reloadSections([.dueDate]) }
        self.mainDataSource.apply(snapshot, animatingDifferences: true)
        let contentHeight = self.mainGoalView.collectionView.contentSize.height
        self.mainGoalView.collectionView.snp.updateConstraints {
          $0.height.greaterThanOrEqualTo(contentHeight)
        }
      }, completion: nil)
    case .subGoal:
      UIView.transition(with: mainGoalView.collectionView, duration: 0.3, options: .curveEaseInOut, animations: {
        var snapshot = self.subGoalAndTaskCreateDataSource.snapshot()
        if isOpen { snapshot.reloadSections([.dueDate]) }
        self.subGoalAndTaskCreateDataSource.apply(snapshot, animatingDifferences: true)
        let contentHeight = self.mainGoalView.collectionView.contentSize.height
        self.mainGoalView.collectionView.snp.updateConstraints {
          $0.height.greaterThanOrEqualTo(contentHeight)
        }
      }, completion: nil)
    case .task:
      switch mode {
      case .create:
        UIView.transition(with: mainGoalView.collectionView, duration: 0.3, options: .curveEaseInOut, animations: {
          var snapshot = self.subGoalAndTaskCreateDataSource.snapshot()
          if isOpen { snapshot.reloadSections([.dueDate]) }
          self.subGoalAndTaskCreateDataSource.apply(snapshot, animatingDifferences: true)
          let contentHeight = self.mainGoalView.collectionView.contentSize.height
          self.mainGoalView.collectionView.snp.updateConstraints {
            $0.height.greaterThanOrEqualTo(contentHeight)
          }
        }, completion: nil)
      case .update:
        UIView.transition(with: mainGoalView.collectionView, duration: 0.3, options: .curveEaseInOut, animations: {
          var snapshot = self.taskUpdateDataSource.snapshot()
          if isOpen { snapshot.reloadSections([.dueDate]) }
          self.taskUpdateDataSource.apply(snapshot, animatingDifferences: true)
          let contentHeight = self.mainGoalView.collectionView.contentSize.height
          self.mainGoalView.collectionView.snp.updateConstraints {
            $0.height.greaterThanOrEqualTo(contentHeight)
          }
        }, completion: nil)
      }
    }
  }
  
  func emojiViewTapped(in cell: EmojiTitleCell) {
    presentPopUp(cell.emojiView, sourceRect: cell.emojiView.bounds)
  }
  
  public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    switch bandalArtCellType {
    case .main:
      switch indexPath.section {
      case 1:
        return true
      default:
        return false
      }
    case .subGoal:
      return false
    case .task:
      return false
    }
  }
}




