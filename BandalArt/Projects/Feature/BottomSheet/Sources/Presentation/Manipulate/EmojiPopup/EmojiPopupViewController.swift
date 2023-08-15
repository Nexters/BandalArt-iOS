//
//  SubGoalAndTaskView.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

struct EmojiPopupViewModel {
  let emojiSelection: PassthroughSubject<Character, Never>
}

final class EmojiPopupViewController: UIViewController {
  let emojiPopupView = EmojiPopupView()
  let viewModel: EmojiPopupViewModel
  private var cancellables = Set<AnyCancellable>()
  
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
  
  let sectionLayoutFactory = SectionLayoutManagerFactory.shared
  var dataSource: UICollectionViewDiffableDataSource<EmojiSection, UUID>!
  
  public init(viewModel: EmojiPopupViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func loadView() {
    super.loadView()
    view = emojiPopupView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupCollectionView()
    bind()
  }
  
  func bind() {
    emojiPopupView.collectionView
      .didSelectItemPublisher
      .compactMap {
        self.emojiItem[$0.row].emoji
      }
      .sink { [weak self] emoji in
        self?.viewModel.emojiSelection.send(emoji)
      }
      .store(in: &cancellables)
  }
  
  func setupCollectionView() {
    emojiPopupView.collectionView.collectionViewLayout = sectionLayoutFactory.createManager(type: .emoji).createLayout()
    setupDataSource()
    emojiPopupView.collectionView.allowsMultipleSelection = false
  }
  
  func setupDataSource() {
    let emojiCellRegistration = UICollectionView.CellRegistration<EmojiCell, EmojiItem> { cell, indexPath, item in
      cell.setupData(item: item)
    }
    
    dataSource = UICollectionViewDiffableDataSource<EmojiSection, UUID>(
      collectionView: emojiPopupView.collectionView
    ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
      let item = self.emojiItem.first(where: { $0.id == identifier })
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
    emojiPopupView.collectionView.dataSource = dataSource
  }
  
}

extension EmojiPopupViewController: UIPopoverPresentationControllerDelegate {
  // 1
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
  
  // 2
  func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
    popoverPresentationController.containerView?.backgroundColor = .clear// UIColor.black.withAlphaComponent(0.3)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.dismiss(animated: false, completion: nil)
  }
}

extension UIViewController {
  func presentPopUp(_ sourceVC: EmojiPopupViewController, button: UIView, sourceRect: CGRect) {
    // 1
    let view = sourceVC
    // 2
    view.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 250)
    // 3
    view.modalPresentationStyle = .popover
    // 4
    view.popoverPresentationController?.delegate = view
    // 5
    view.popoverPresentationController?.permittedArrowDirections = .up
    // 6
    view.popoverPresentationController?.sourceView = button
    // 7
    view.popoverPresentationController?.sourceRect = sourceRect
    // 8
    view.view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
    view.view.layer.shadowOpacity = 1
    view.view.layer.shadowRadius = 30
    view.view.layer.shadowOffset = CGSize(width: 0, height: -4)
    self.present(view, animated: false, completion: {
      view.view.superview?.layer.cornerRadius = 4.0
    })
  }
}
