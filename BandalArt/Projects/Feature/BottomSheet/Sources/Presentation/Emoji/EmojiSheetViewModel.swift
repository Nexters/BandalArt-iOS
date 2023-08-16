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
  
  public init(
    useCase: BandalArtUseCase = BandalArtUseCaseImpl(
      repository: BandalArtRepositoryImpl()
    ),
    mainInfo: BandalArtInfo
  ) {
    self.mainGoalInfo = mainInfo
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
  
  func transform(input: Input) -> Output {
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
    
    
    return Output(
      selectEmoji: selectEmoji.eraseToAnyPublisher(),
      updateHomeDelegate: updateHomeDelegateSubject.eraseToAnyPublisher(),
      dismissBottomSheet: dismissBottomSheetSubject.eraseToAnyPublisher(),
      showCompleteToast: showCompleteToastSubject.eraseToAnyPublisher()
    )
  }
  
  
}
