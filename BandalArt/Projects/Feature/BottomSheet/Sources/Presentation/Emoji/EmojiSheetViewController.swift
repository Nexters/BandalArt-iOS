//
//  EmojiSheetViewController.swift
//  BottomSheetFeature
//
//  Created by Sang hun Lee on 2023/08/09.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Components

enum EmojiSection {
  case main
}

public final class EmojiSheetViewController: BottomSheetController {
  let emojiSelectionView = EmojiSelectionView()
  let sectionLayoutFactory = SectionLayoutManagerFactory.shared
  
  var dataSource: UICollectionViewDiffableDataSource<EmojiSection, UUID>!
  
  public init() {
    super.init(nibName: nil, bundle: nil)
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

