//
//  EmojiSheetViewController.swift
//  BottomSheetFeature
//
//  Created by Sang hun Lee on 2023/08/09.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Components
import Combine
import CombineCocoa

enum EmojiSection {
  case main
}

public final class EmojiSheetViewController: BottomSheetController {
  let emojiSelectionView = EmojiSheetView()
  let sectionLayoutFactory = SectionLayoutManagerFactory.shared
  let viewModel: EmojiSheetViewModel
  var dataSource: UICollectionViewDiffableDataSource<EmojiSection, UUID>!
  public weak var delegate: ManipulateViewControllerDelegate?
  
  public init(viewModel: EmojiSheetViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func loadView() {
    super.loadView()
    view = emojiSelectionView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupCollectionView()
    
  }
  
  public override func bind() {
    let input = EmojiSheetViewModel.Input(
      emojiSelection: emojiSelectionView.collectionView.didDeselectItemPublisher,
      completionButtonTap: emojiSelectionView.completionButton.tapPublisher
    )
    
    let output = viewModel.transform(input: input)
    
    output.selectEmoji
      .receive(on: DispatchQueue.main)
      .sink { [weak self] row in
        self?.emojiSelectionView.collectionView.selectItem(
          at: IndexPath(item: row, section: 1),
          animated: true,
          scrollPosition: .top
        )
      }
      .store(in: &cancellables)
    
    output.dismissBottomSheet
      .sink { [weak self] event in
        self?.dismiss(animated: true)
      }
      .store(in: &cancellables)
    
    output.showCompleteToast
      .receive(on: DispatchQueue.main)
      .sink { [weak self] msg in
        print("Toast \(msg)")
      }
      .store(in: &cancellables)
    
    output.updateHomeDelegate
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.delegate?.didModifyed()
      }
      .store(in: &cancellables)
  }
  
  func setupCollectionView() {
    emojiSelectionView.collectionView.collectionViewLayout = sectionLayoutFactory.createManager(type: .emoji).createLayout()
    setupDataSource()
    emojiSelectionView.collectionView.allowsMultipleSelection = false
  }
  
  func setupDataSource() {
    let emojiItem = [
      EmojiItem(id: UUID(), emoji: "🔥"),
      EmojiItem(id: UUID(), emoji: "😀"),
      EmojiItem(id: UUID(), emoji: "😃"),
      EmojiItem(id: UUID(), emoji: "😄"),
      EmojiItem(id: UUID(), emoji: "😆"),
      EmojiItem(id: UUID(), emoji: "🥹"),
      
      EmojiItem(id: UUID(), emoji: "🥰"),
      EmojiItem(id: UUID(), emoji: "😍"),
      EmojiItem(id: UUID(), emoji: "😂"),
      EmojiItem(id: UUID(), emoji: "🥲"),
      EmojiItem(id: UUID(), emoji: "☺️"),
      EmojiItem(id: UUID(), emoji: "😎"),
      
      EmojiItem(id: UUID(), emoji: "🥳"),
      EmojiItem(id: UUID(), emoji: "🤩"),
      EmojiItem(id: UUID(), emoji: "⭐️"),
      EmojiItem(id: UUID(), emoji: "🌟"),
      EmojiItem(id: UUID(), emoji: "✨"),
      EmojiItem(id: UUID(), emoji: "💥"),
      
      EmojiItem(id: UUID(), emoji: "❤️"),
      EmojiItem(id: UUID(), emoji: "🧡"),
      EmojiItem(id: UUID(), emoji: "💛"),
      EmojiItem(id: UUID(), emoji: "💚"),
      EmojiItem(id: UUID(), emoji: "💙"),
      EmojiItem(id: UUID(), emoji: "❤️‍🔥")
    ]
    
    let emojiCellRegistration = UICollectionView.CellRegistration<EmojiCell, EmojiItem> { cell, indexPath, item in
      cell.setupData(item: item)
    }
    
    dataSource = UICollectionViewDiffableDataSource<EmojiSection, UUID>(
      collectionView: emojiSelectionView.collectionView
    ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
      let item = emojiItem.first(where: { $0.id == identifier })
      return collectionView.dequeueConfiguredReusableCell(
        using: emojiCellRegistration,
        for: indexPath, item: item
      )
    }
    
    var snapshot = NSDiffableDataSourceSnapshot<EmojiSection, UUID>()
    snapshot.appendSections([.main])
    snapshot.appendItems(emojiItem.map{ $0.id }, toSection: .main)
  
    dataSource.supplementaryViewProvider = nil
    
    dataSource.apply(snapshot, animatingDifferences: false)
    emojiSelectionView.collectionView.dataSource = dataSource
  }
}

