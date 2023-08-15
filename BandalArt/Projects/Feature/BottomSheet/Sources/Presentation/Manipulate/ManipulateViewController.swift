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

  public weak var delegate: ManipulateViewControllerDelegate?

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
      viewDidLoad: didLoadPublisher.eraseToAnyPublisher(),
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

    output.changeDueDateHeight
      .receive(on: DispatchQueue.main)
      .sink { [weak self] dueDateItemId in
        guard let self = self else { return }
        let value = viewModel.isOpenDueDate.value
        viewModel.isOpenDueDate.send(!value)
        switch bandalArtCellType {
        case .mainGoal:
          var snapshot = mainDataSource.snapshot()
          snapshot.reloadSections([.dueDate])
          mainDataSource.apply(snapshot, animatingDifferences: true)
        case .subGoal:
          var snapshot = subGoalAndTaskCreateDataSource.snapshot()
          snapshot.reloadSections([.dueDate])
          subGoalAndTaskCreateDataSource.apply(snapshot, animatingDifferences: true)
        case .task:
          switch mode {
          case .create:
            var snapshot = subGoalAndTaskCreateDataSource.snapshot()
            snapshot.reloadSections([.dueDate])
            subGoalAndTaskCreateDataSource.apply(snapshot, animatingDifferences: true)
          case .update:
            var snapshot = taskUpdateDataSource.snapshot()
            snapshot.reloadSections([.dueDate])
            taskUpdateDataSource.apply(snapshot, animatingDifferences: true)
          }
        }
        let contentHeight = manipulateView.collectionView.contentSize.height
        manipulateView.collectionView.snp.updateConstraints {
          $0.height.greaterThanOrEqualTo(contentHeight)
        }
      }
      .store(in: &cancellables)
    
    output.selectColor
      .receive(on: DispatchQueue.main)
      .sink { [weak self] row in
        self?.manipulateView.collectionView.selectItem(
          at: IndexPath(item: row, section: 1),
          animated: true,
          scrollPosition: .top
        )
      }
      .store(in: &cancellables)
    
    output.updateHomeDelegate
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.delegate?.didModifyed()
      }
      .store(in: &cancellables)
    
    output.showDeleteAlert
      .receive(on: DispatchQueue.main)
      .sink { [weak self] title in
        guard let self = self else { return }
        let title = "'\(title)'\n\(self.bandalArtCellType.title)를 삭제하시겠어요?"
        let message = self.bandalArtCellType.message
        
        self.showPopUp(title: title, message: message, leftActionTitle: "취소", rightActionTitle: "삭제하기")
      }
      .store(in: &cancellables)
    
    didLoadPublisher.send(Void())
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
          let item = self.viewModel.emojiTitleItem.value.first(where: { $0.id == identifier })
          return collectionView.dequeueConfiguredReusableCell(
            using: emojiTitleCellRegistration,
            for: indexPath, item: item)
        case 1:
          let item = self.viewModel.themeColorItem.value.first(where: { $0.id == identifier })
          return collectionView.dequeueConfiguredReusableCell(
            using: themeColorCellRegistration,
            for: indexPath, item: item)
        case 2:
          let item = self.viewModel.dueDateItem.value.first(where: { $0.id == identifier })
          return collectionView.dequeueConfiguredReusableCell(
            using: dueDateCellRegistration,
            for: indexPath, item: item)
        case 3:
          let item = self.viewModel.memoItem.value.first(where: { $0.id == identifier })
          return collectionView.dequeueConfiguredReusableCell(
            using: memoCellRegistration,
            for: indexPath, item: item)
        default:
          return UICollectionViewCell()
        }
      }

      var snapshot = NSDiffableDataSourceSnapshot<MainGoalSection, UUID>()

      snapshot.appendSections([.emojiTitle])
      snapshot.appendItems(self.viewModel.emojiTitleItem.value.map{ $0.id }, toSection: .emojiTitle)

      snapshot.appendSections([.themeColor])
      snapshot.appendItems(self.viewModel.themeColorItem.value.map{ $0.id }, toSection: .themeColor)

      snapshot.appendSections([.dueDate])
      snapshot.appendItems(self.viewModel.dueDateItem.value.map{ $0.id }, toSection: .dueDate)

      snapshot.appendSections([.memo])
      snapshot.appendItems(self.viewModel.memoItem.value.map{ $0.id }, toSection: .memo)

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
          let item = self.viewModel.titleItem.value.first(where: { $0.id == identifier })
          return collectionView.dequeueConfiguredReusableCell(
            using: titleCellRegistration,
            for: indexPath, item: item)
        case 1:
          let item = self.viewModel.dueDateItem.value.first(where: { $0.id == identifier })
          return collectionView.dequeueConfiguredReusableCell(
            using: dueDateCellRegistration,
            for: indexPath, item: item)
        case 2:
          let item = self.viewModel.memoItem.value.first(where: { $0.id == identifier })
          return collectionView.dequeueConfiguredReusableCell(
            using: memoCellRegistration,
            for: indexPath, item: item)
        default:
          return UICollectionViewCell()
        }
      }

      var snapshot = NSDiffableDataSourceSnapshot<SubGoalAndTaskCreateSection, UUID>()

      snapshot.appendSections([.title])
      snapshot.appendItems(self.viewModel.titleItem.value.map{ $0.id }, toSection: .title)

      snapshot.appendSections([.dueDate])
      snapshot.appendItems(self.viewModel.dueDateItem.value.map{ $0.id }, toSection: .dueDate)

      snapshot.appendSections([.memo])
      snapshot.appendItems(self.viewModel.memoItem.value.map{ $0.id }, toSection: .memo)

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
            let item = self.viewModel.titleItem.value.first(where: { $0.id == identifier })
            return collectionView.dequeueConfiguredReusableCell(
              using: titleCellRegistration,
              for: indexPath, item: item)
          case 1:
            let item = self.viewModel.dueDateItem.value.first(where: { $0.id == identifier })
            return collectionView.dequeueConfiguredReusableCell(
              using: dueDateCellRegistration,
              for: indexPath, item: item)
          case 2:
            let item = self.viewModel.memoItem.value.first(where: { $0.id == identifier })
            return collectionView.dequeueConfiguredReusableCell(
              using: memoCellRegistration,
              for: indexPath, item: item)
          default:
            return UICollectionViewCell()
          }
        }

        var snapshot = NSDiffableDataSourceSnapshot<SubGoalAndTaskCreateSection, UUID>()

        snapshot.appendSections([.title])
        snapshot.appendItems(self.viewModel.titleItem.value.map{ $0.id }, toSection: .title)

        snapshot.appendSections([.dueDate])
        snapshot.appendItems(self.viewModel.dueDateItem.value.map{ $0.id }, toSection: .dueDate)

        snapshot.appendSections([.memo])
        snapshot.appendItems(self.viewModel.memoItem.value.map{ $0.id }, toSection: .memo)

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
            let item = self.viewModel.titleItem.value.first(where: { $0.id == identifier })
            return collectionView.dequeueConfiguredReusableCell(
              using: titleCellRegistration,
              for: indexPath, item: item)
          case 1:
            let item = self.viewModel.dueDateItem.value.first(where: { $0.id == identifier })
            return collectionView.dequeueConfiguredReusableCell(
              using: dueDateCellRegistration,
              for: indexPath, item: item)
          case 2:
            let item = self.viewModel.memoItem.value.first(where: { $0.id == identifier })
            return collectionView.dequeueConfiguredReusableCell(
              using: memoCellRegistration,
              for: indexPath, item: item)
          case 3:
            let item = self.viewModel.completionItem.value.first(where: { $0.id == identifier })
            return collectionView.dequeueConfiguredReusableCell(
              using: completionCellRegistration,
              for: indexPath, item: item)
          default:
            return UICollectionViewCell()
          }
        }

        var snapshot = NSDiffableDataSourceSnapshot<TaskUpdateSection, UUID>()

        snapshot.appendSections([.title])
        snapshot.appendItems(self.viewModel.titleItem.value.map{ $0.id }, toSection: .title)

        snapshot.appendSections([.dueDate])
        snapshot.appendItems(self.viewModel.dueDateItem.value.map{ $0.id }, toSection: .dueDate)

        snapshot.appendSections([.memo])
        snapshot.appendItems(self.viewModel.memoItem.value.map{ $0.id }, toSection: .memo)

        snapshot.appendSections([.completion])
        snapshot.appendItems(self.viewModel.completionItem.value.map{ $0.id }, toSection: .completion)

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

extension ManipulateViewController: EmojiSelectorDelegate {
  func emojiViewTapped(in cell: EmojiTitleCell) {
    self.view.endEditing(true)
    presentPopUp(
      EmojiPopupViewController(viewModel: viewModel.emojiPopupViewModel),
      button: cell.emojiView,
      sourceRect: cell.emojiView.bounds
    )
  }
}




