//
//  MainGoalViewController.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Entity
import Combine
import CombineCocoa
import Components
import CommonFeature

protocol DatePickerCallDelegate: AnyObject {
  func datePickerButtonTapped(in cell: DueDateCell, isOpen: Bool)
}

protocol EmojiSelectorDelegate: AnyObject {
  func emojiViewTapped(in cell: EmojiTitleCell)
}

public protocol ManipulateViewControllerDelegate: AnyObject {
    func didModifyed()
}

public final class ManipulateViewController: BottomSheetController {
  let mode: Mode
  let bandalArtCellType: BandalArtCellType
  
  let manipulateView: ManipulateView
  let viewModel: ManipulateViewModel
 
  let sectionLayoutFactory = SectionLayoutManagerFactory.shared
  var mainDataSource: UICollectionViewDiffableDataSource<MainGoalSection, UUID>!
  var subGoalAndTaskCreateDataSource:  UICollectionViewDiffableDataSource<SubGoalAndTaskCreateSection, UUID>!
  var taskUpdateDataSource: UICollectionViewDiffableDataSource<TaskUpdateSection, UUID>!

  weak var delegate: ManipulateViewControllerDelegate?

  public init(
    mode: Mode,
    bandalArtCellType: BandalArtCellType,
    viewModel: ManipulateViewModel
  ) {
    self.manipulateView = ManipulateView(
      mode: mode,
      bandalArtCellType: bandalArtCellType,
      frame: .zero
    )
    self.mode = mode
    self.bandalArtCellType = bandalArtCellType
    self.viewModel = viewModel
    
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func loadView() {
    super.loadView()
    view = manipulateView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupCollectionView()
    setupKeyboard()
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    adjustCollectionViewHeight()
  }
  
  public override func bind() {
    let didLoadPublisher = PassthroughSubject<Void, Never>()
  
    let input = ManipulateViewModel.Input(
      didViewLoad: didLoadPublisher.eraseToAnyPublisher(),
      themeColorSelection: manipulateView.collectionView.didSelectItemPublisher,
      deleteButtonTap: manipulateView.deleteButton.tapPublisher,
      completionButtonTap: manipulateView.completionButton.tapPublisher,
      closeButtonTap: manipulateView.closeButton.tapPublisher
    )
    let output = viewModel.transform(input: input)
    
    output.completionButtonEnable
      .sink { [weak self] enable in
        self?.manipulateView.completionButton.isEnabled = enable
      }
      .store(in: &cancellables)
    
    output.dismissBottomSheet
      .sink { [weak self] event in
        self?.dismiss(animated: true)
      }
      .store(in: &cancellables)
    
//    output.title
//      .combineLatest(output.dueDate, output.memo, output.completion)
//      .sink(receiveValue: { [weak self] (title, dusDate, memo, completion) in
//        self?.viewModel.titleItem.first?.title = title
//      })
//      .store(in: &cancellables)
    
    
    
  }
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  func adjustCollectionViewHeight() {
    guard manipulateView.collectionView.contentSize.height != 0 else { return }
    let contentHeight = manipulateView.collectionView.contentSize.height
    manipulateView.collectionView.snp.updateConstraints {
      $0.height.greaterThanOrEqualTo(contentHeight)
    }
  }
  
  func setupCollectionView() {
    switch bandalArtCellType {
    case .mainGoal:
      manipulateView.collectionView.collectionViewLayout = sectionLayoutFactory.createManager(
        type: .mainGoal
      ).createLayout()
    default:
      manipulateView.collectionView.collectionViewLayout = sectionLayoutFactory.createManager(
        type: .subGoalAndTask
      ).createLayout()
    }
    setupDataSource()
    manipulateView.collectionView.allowsMultipleSelection = false
  }
  
  func setupKeyboard() {
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
      .sink { [weak self] notification in
        guard let self = self else { return }
        
        if self.view.window?.frame.origin.y == 0 {
          if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.adjustLayoutForKeyboard(height: keyboardFrame.height)
          }
        }
      }
      .store(in: &cancellables)
    
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
      .sink { [weak self] notification in
        guard let self = self else { return }
        if self.view.window?.frame.origin.y != 0 {
          if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.resetLayout(height: keyboardFrame.height)
          }
        }
      }
      .store(in: &cancellables)
  }
  
  private func adjustLayoutForKeyboard(height: CGFloat) {
    UIView.animate(withDuration: 1) {
      self.view.window?.frame.origin.y -= height
    }
  }
  
  private func resetLayout(height: CGFloat) {
    UIView.animate(withDuration: 1) {
      self.view.window?.frame.origin.y += height
    }
  }

  func setupDataSource() {
    // TODO: setupData 까먹지 말기
    let emojiTitleCellRegistration = UICollectionView.CellRegistration<EmojiTitleCell, EmojiTitleItem> { cell, indexPath, item in
      cell.setupData(item: item)
      cell.configure(with: self.viewModel.emojiTitleCellViewModel)
      cell.delegate = self
    }
    let titleCellRegistration = UICollectionView.CellRegistration<TitleCell, TitleItem> { cell, indexPath, item in
      cell.setupData(item: item)
      cell.configure(with: self.viewModel.titleCellViewModel)
    }
    let themeColorCellRegistration = UICollectionView.CellRegistration<ThemeColorCell, ThemeColorItem> { cell, indexPath, item in
      cell.setupData(item: item)
    }
    let dueDateCellRegistration = UICollectionView.CellRegistration<DueDateCell, DueDateItem> { cell, indexPath, item in
      cell.setupData(item: item)
      cell.delegate = self
      cell.configure(with: self.viewModel.dueDateCellViewModel)
    }
    let memoCellRegistration = UICollectionView.CellRegistration<MemoCell, MemoItem> { cell, indexPath, item in
      cell.setupData(item: item)
      cell.configure(with: self.viewModel.memoCellViewModel)
    }
    let completionCellRegistration = UICollectionView.CellRegistration<CompletionCell, CompletionItem> { cell, indexPath, item in
      cell.setupData(item: item)
      cell.configure(with: self.viewModel.completionCellViewModel)
    }
    
    switch bandalArtCellType {
    case .mainGoal:
      mainDataSource = UICollectionViewDiffableDataSource<MainGoalSection, UUID>(
            collectionView: manipulateView.collectionView
          ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            switch indexPath.section {
            case 0:
              let item = self.viewModel.emojiTitleItem.first(where: { $0.id == identifier })
              return collectionView.dequeueConfiguredReusableCell(
                using: emojiTitleCellRegistration,
                for: indexPath, item: item)
            case 1:
              let item = self.viewModel.themeColorItem.first(where: { $0.id == identifier })
              return collectionView.dequeueConfiguredReusableCell(
                using: themeColorCellRegistration,
                for: indexPath, item: item)
            case 2:
              let item = self.viewModel.dueDateItem.first(where: { $0.id == identifier })
              return collectionView.dequeueConfiguredReusableCell(
                using: dueDateCellRegistration,
                for: indexPath, item: item)
            case 3:
              let item = self.viewModel.memoItem.first(where: { $0.id == identifier })
              return collectionView.dequeueConfiguredReusableCell(
                using: memoCellRegistration,
                for: indexPath, item: item)
            default:
              return UICollectionViewCell()
            }
          }

      var snapshot = NSDiffableDataSourceSnapshot<MainGoalSection, UUID>()
      
      snapshot.appendSections([.emojiTitle])
      snapshot.appendItems(self.viewModel.emojiTitleItem.map{ $0.id }, toSection: .emojiTitle)

      snapshot.appendSections([.themeColor])
      snapshot.appendItems(self.viewModel.themeColorItem.map{ $0.id }, toSection: .themeColor)

      snapshot.appendSections([.dueDate])
      snapshot.appendItems(self.viewModel.dueDateItem.map{ $0.id }, toSection: .dueDate)
      
      snapshot.appendSections([.memo])
      snapshot.appendItems(self.viewModel.memoItem.map{ $0.id }, toSection: .memo)
      
      let headerRegistration = UICollectionView.SupplementaryRegistration
      <BottomSheetSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) {
        (supplementaryView, string, indexPath) in
        let headerItem = self.mainDataSource.snapshot().sectionIdentifiers[indexPath.section]
        supplementaryView.setupData(header: headerItem.title)
      }

      mainDataSource.supplementaryViewProvider = { (view, kind, index) in
        return self.manipulateView.collectionView.dequeueConfiguredReusableSupplementary(
          using: headerRegistration, for: index)
      }
      
      mainDataSource.apply(snapshot, animatingDifferences: false)
    case .subGoal:
      subGoalAndTaskCreateDataSource = UICollectionViewDiffableDataSource<SubGoalAndTaskCreateSection, UUID>(
            collectionView: manipulateView.collectionView
          ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            switch indexPath.section {
            case 0:
              let item = self.viewModel.titleItem.first(where: { $0.id == identifier })
              return collectionView.dequeueConfiguredReusableCell(
                using: titleCellRegistration,
                for: indexPath, item: item)
            case 1:
              let item = self.viewModel.dueDateItem.first(where: { $0.id == identifier })
              return collectionView.dequeueConfiguredReusableCell(
                using: dueDateCellRegistration,
                for: indexPath, item: item)
            case 2:
              let item = self.viewModel.memoItem.first(where: { $0.id == identifier })
              return collectionView.dequeueConfiguredReusableCell(
                using: memoCellRegistration,
                for: indexPath, item: item)
            default:
              return UICollectionViewCell()
            }
          }

      var snapshot = NSDiffableDataSourceSnapshot<SubGoalAndTaskCreateSection, UUID>()
      
      snapshot.appendSections([.title])
      snapshot.appendItems(self.viewModel.titleItem.map{ $0.id }, toSection: .title)

      snapshot.appendSections([.dueDate])
      snapshot.appendItems(self.viewModel.dueDateItem.map{ $0.id }, toSection: .dueDate)
      
      snapshot.appendSections([.memo])
      snapshot.appendItems(self.viewModel.memoItem.map{ $0.id }, toSection: .memo)
      
      let headerRegistration = UICollectionView.SupplementaryRegistration
      <BottomSheetSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) {
        (supplementaryView, string, indexPath) in
        let headerItem = self.subGoalAndTaskCreateDataSource.snapshot().sectionIdentifiers[indexPath.section]
        supplementaryView.setupData(header: headerItem.title)
      }

      subGoalAndTaskCreateDataSource.supplementaryViewProvider = { (view, kind, index) in
        return self.manipulateView.collectionView.dequeueConfiguredReusableSupplementary(
          using: headerRegistration, for: index)
      }
      
      subGoalAndTaskCreateDataSource.apply(snapshot, animatingDifferences: false)
    case .task:
      switch mode {
      case .create:
        subGoalAndTaskCreateDataSource = UICollectionViewDiffableDataSource<SubGoalAndTaskCreateSection, UUID>(
              collectionView: manipulateView.collectionView
            ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
              switch indexPath.section {
              case 0:
                let item = self.viewModel.titleItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: titleCellRegistration,
                  for: indexPath, item: item)
              case 1:
                let item = self.viewModel.dueDateItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: dueDateCellRegistration,
                  for: indexPath, item: item)
              case 2:
                let item = self.viewModel.memoItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: memoCellRegistration,
                  for: indexPath, item: item)
              default:
                return UICollectionViewCell()
              }
            }

        var snapshot = NSDiffableDataSourceSnapshot<SubGoalAndTaskCreateSection, UUID>()
        
        snapshot.appendSections([.title])
        snapshot.appendItems(self.viewModel.titleItem.map{ $0.id }, toSection: .title)

        snapshot.appendSections([.dueDate])
        snapshot.appendItems(self.viewModel.dueDateItem.map{ $0.id }, toSection: .dueDate)
        
        snapshot.appendSections([.memo])
        snapshot.appendItems(self.viewModel.memoItem.map{ $0.id }, toSection: .memo)
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <BottomSheetSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) {
          (supplementaryView, string, indexPath) in
          let headerItem = self.subGoalAndTaskCreateDataSource.snapshot().sectionIdentifiers[indexPath.section]
          supplementaryView.setupData(header: headerItem.title)
        }

        subGoalAndTaskCreateDataSource.supplementaryViewProvider = { (view, kind, index) in
          return self.manipulateView.collectionView.dequeueConfiguredReusableSupplementary(
            using: headerRegistration, for: index)
        }
        
        subGoalAndTaskCreateDataSource.apply(snapshot, animatingDifferences: false)
      case .update:
        taskUpdateDataSource = UICollectionViewDiffableDataSource<TaskUpdateSection, UUID>(
              collectionView: manipulateView.collectionView
            ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
              switch indexPath.section {
              case 0:
                let item = self.viewModel.titleItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: titleCellRegistration,
                  for: indexPath, item: item)
              case 1:
                let item = self.viewModel.dueDateItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: dueDateCellRegistration,
                  for: indexPath, item: item)
              case 2:
                let item = self.viewModel.memoItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: memoCellRegistration,
                  for: indexPath, item: item)
              case 3:
                let item = self.viewModel.completionItem.first(where: { $0.id == identifier })
                return collectionView.dequeueConfiguredReusableCell(
                  using: completionCellRegistration,
                  for: indexPath, item: item)
              default:
                return UICollectionViewCell()
              }
            }

        var snapshot = NSDiffableDataSourceSnapshot<TaskUpdateSection, UUID>()
        
        snapshot.appendSections([.title])
        snapshot.appendItems(self.viewModel.titleItem.map{ $0.id }, toSection: .title)

        snapshot.appendSections([.dueDate])
        snapshot.appendItems(self.viewModel.dueDateItem.map{ $0.id }, toSection: .dueDate)
        
        snapshot.appendSections([.memo])
        snapshot.appendItems(self.viewModel.memoItem.map{ $0.id }, toSection: .memo)
        
        snapshot.appendSections([.completion])
        snapshot.appendItems(self.viewModel.completionItem.map{ $0.id }, toSection: .completion)
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <BottomSheetSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) {
          (supplementaryView, string, indexPath) in
          let headerItem = self.taskUpdateDataSource.snapshot().sectionIdentifiers[indexPath.section]
          supplementaryView.setupData(header: headerItem.title)
        }

        taskUpdateDataSource.supplementaryViewProvider = { (view, kind, index) in
          return self.manipulateView.collectionView.dequeueConfiguredReusableSupplementary(
            using: headerRegistration, for: index)
        }
        
        taskUpdateDataSource.apply(snapshot, animatingDifferences: false)
      }
    }

    switch bandalArtCellType {
    case .mainGoal:
      manipulateView.collectionView.dataSource = mainDataSource
      manipulateView.collectionView.selectItem(
        at: IndexPath(item: 0, section: 1),
        animated: true,
        scrollPosition: .top
      )
    case .subGoal:
      manipulateView.collectionView.dataSource = subGoalAndTaskCreateDataSource
    case .task:
      switch mode {
      case .create:
        manipulateView.collectionView.dataSource = subGoalAndTaskCreateDataSource
      case .update:
        manipulateView.collectionView.dataSource = taskUpdateDataSource
      }
    }
  }
}

extension ManipulateViewController: UICollectionViewDelegate, DatePickerCallDelegate, EmojiSelectorDelegate {
  func datePickerButtonTapped(in cell: DueDateCell, isOpen: Bool) {
    self.view.endEditing(true)
    switch bandalArtCellType {
    case .mainGoal:
      UIView.transition(with: manipulateView.collectionView, duration: 0.3, options: .curveEaseInOut, animations: {
//        var snapshot = self.mainDataSource.snapshot()
        self.manipulateView.collectionView.reloadData()
//        self.mainDataSource.apply(snapshot, animatingDifferences: true)
        let contentHeight = self.manipulateView.collectionView.contentSize.height
        self.manipulateView.collectionView.snp.updateConstraints {
          $0.height.greaterThanOrEqualTo(contentHeight)
        }
      }, completion: nil)
    case .subGoal:
      UIView.transition(with: manipulateView.collectionView, duration: 0.3, options: .curveEaseInOut, animations: {
//        var snapshot = self.subGoalAndTaskCreateDataSource.snapshot()
//        // if isOpen { snapshot.reloadSections([.dueDate]) }
        self.manipulateView.collectionView.reloadData()
//        self.subGoalAndTaskCreateDataSource.apply(snapshot, animatingDifferences: true)
        let contentHeight = self.manipulateView.collectionView.contentSize.height
        self.manipulateView.collectionView.snp.updateConstraints {
          $0.height.greaterThanOrEqualTo(contentHeight)
        }
      }, completion: nil)
    case .task:
      switch mode {
      case .create:
        UIView.transition(with: manipulateView.collectionView, duration: 0.3, options: .curveEaseInOut, animations: {
          var snapshot = self.subGoalAndTaskCreateDataSource.snapshot()
          // if isOpen { snapshot.reloadSections([.dueDate]) }
          self.manipulateView.collectionView.reloadData()
          self.subGoalAndTaskCreateDataSource.apply(snapshot, animatingDifferences: true)
          let contentHeight = self.manipulateView.collectionView.contentSize.height
          self.manipulateView.collectionView.snp.updateConstraints {
            $0.height.greaterThanOrEqualTo(contentHeight)
          }
        }, completion: nil)
      case .update:
        UIView.transition(with: manipulateView.collectionView, duration: 0.3, options: .curveEaseInOut, animations: {
//          var snapshot = self.taskUpdateDataSource.snapshot()
          // if isOpen { snapshot.reloadSections([.dueDate]) }
          self.manipulateView.collectionView.reloadData()
//          self.taskUpdateDataSource.apply(snapshot, animatingDifferences: true)
          let contentHeight = self.manipulateView.collectionView.contentSize.height
          self.manipulateView.collectionView.snp.updateConstraints {
            $0.height.greaterThanOrEqualTo(contentHeight)
          }
        }, completion: nil)
      }
    }
  }
  
  func emojiViewTapped(in cell: EmojiTitleCell) {
    self.view.endEditing(true)
    presentPopUp(
      EmojiPopupViewController(viewModel: viewModel.emojiPopupViewModel),
      button: cell.emojiView,
      sourceRect: cell.emojiView.bounds
    )
  }
}




