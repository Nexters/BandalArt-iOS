//
//  EmojiSheetViewModel.swift
//  BottomSheetFeature
//
//  Created by Sang hun Lee on 2023/08/11.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Combine
import UseCase
import Entity
import Network
import Util

public final class EmojiSheetViewModel: ViewModelType {
  private var cancellables = Set<AnyCancellable>()
  var mainGoalInfo: BandalArtInfo
  private let useCase: BandalArtUseCase
  
  public init(
    useCase: BandalArtUseCase = BandalArtUseCaseImpl(
      repository: BandalArtRepositoryImpl()
    ),
    mainInfo: BandalArtInfo
  ) {
    self.mainGoalInfo = mainInfo
    self.useCase = useCase
    emojiSubject.send(mainInfo.profileEmojiText)
  }
  
  struct Input {
    let viewDidLoad: AnyPublisher<Void, Never>
    let emojiSelection: AnyPublisher<IndexPath, Never>
    let completionButtonTap: AnyPublisher<Void, Never>
  }
  
  struct Output {
    let selectEmoji: AnyPublisher<Int, Never>
    let updateHomeDelegate: AnyPublisher<Void,Never>
    let dismissBottomSheet: AnyPublisher<Void,Never>
    let showCompleteToast: AnyPublisher<String, Never>
  }
  
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
  
  var selectEmoji = PassthroughSubject<Int, Never>()
  private let updateHomeDelegateSubject = PassthroughSubject<Void, Never>()
  private let dismissBottomSheetSubject = PassthroughSubject<Void, Never>()
  private let showCompleteToastSubject = PassthroughSubject<String, Never>()
  private let emojiSubject = CurrentValueSubject<Character?, Never>(nil)
  
  func transform(input: Input) -> Output {
    self.bindUseCase()
    
    input.viewDidLoad
      .sink { [weak self] _ in
        guard let self = self else { return }
        let emoji = self.mainGoalInfo.profileEmojiText
        guard let selected = emojiItem.enumerated().filter({ (index, item) in
          item.emoji == emoji
        }).first else { return }
        self.selectEmoji.send(selected.offset)
      }
      .store(in: &cancellables)
    
    input.completionButtonTap
      .sink { [weak self] _ in
        guard let self = self else { return }
        updateEmoji(key: UserDefaultsManager.lastUserBandalArtKey ?? "", cellKey: mainGoalInfo.mainCellKey)
      }
      .store(in: &cancellables)
    
    input.emojiSelection
      .removeDuplicates()
      .sink { [weak self] indexPath in
        guard let self = self else { return }
        guard let selected = emojiItem.enumerated().filter({ (index, item) in
          return index == indexPath.row
        }).first else { return }
        print(selected.element.emoji)
        self.emojiSubject.send(selected.element.emoji)
      }
      .store(in: &cancellables)
    
    return Output(
      selectEmoji: selectEmoji.eraseToAnyPublisher(),
      updateHomeDelegate: updateHomeDelegateSubject.eraseToAnyPublisher(),
      dismissBottomSheet: dismissBottomSheetSubject.eraseToAnyPublisher(),
      showCompleteToast: showCompleteToastSubject.eraseToAnyPublisher()
    )
  }
  
  private func bindUseCase() {
    self.useCase.cellUpdateCompletionSubject
      .sink { [weak self] completion in
        self?.updateHomeDelegateSubject.send(Void())
        self?.dismissBottomSheetSubject.send(Void())
        // 업데이트 완료 Toast
      }
      .store(in: &cancellables)
  }
}

private extension EmojiSheetViewModel {
  func updateEmoji(key: String, cellKey: String) {
    self.useCase.updateBandalArtTask(
      key: key,
      cellKey: cellKey,
      profileEmoji: emojiSubject.value,
      title: mainGoalInfo.title,
      description: nil,
      dueDate: mainGoalInfo.dueDate,
      mainColor: mainGoalInfo.mainColorHexString,
      subColor: "#111827"
    )
  }
}
