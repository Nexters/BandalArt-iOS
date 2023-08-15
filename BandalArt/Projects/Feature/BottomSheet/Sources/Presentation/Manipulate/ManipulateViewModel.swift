//
//  ManipulateViewModel.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Combine
import UseCase
import Entity
import Network
import Util

import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

public final class ManipulateViewModel: ViewModelType {
  private let useCase: BandalArtUseCase
  private var cancellables = Set<AnyCancellable>()
  var mode: Mode
  var bandalArtCellType: BandalArtCellType
  
  /// subGoal & Task Info
  var subGoalAndTaskInfo: BandalArtCellInfo
  /// mainGoal - 이모지
  var mainGoalInfo: BandalArtInfo?

  
  var emojiTitleItem = [EmojiTitleItem(id: UUID(), emoji: Character("."), title: "")]
  let themeColorItem = [
    ThemeColorItem(id: UUID(), color: .mint),
    ThemeColorItem(id: UUID(), color: .grape),
    ThemeColorItem(id: UUID(), color: .sky),
    ThemeColorItem(id: UUID(), color: .grass),
    ThemeColorItem(id: UUID(), color: .lemon),
    ThemeColorItem(id: UUID(), color: .mandarin)
  ]
  
  var titleItem: [TitleItem]
  var dueDateItem: [DueDateItem]
  var memoItem: [MemoItem]
  var completionItem: [CompletionItem]
  
  public init(
    useCase: BandalArtUseCase = BandalArtUseCaseImpl(
      repository: BandalArtRepositoryImpl()
    ),
    cellInfo: BandalArtCellInfo,
    mainInfo: BandalArtInfo?,
    mode: Mode,
    bandalArtCellType: BandalArtCellType
  ) {
    self.useCase = useCase
    self.subGoalAndTaskInfo = cellInfo
    self.mainGoalInfo = mainInfo
    self.mode = mode
    self.bandalArtCellType = bandalArtCellType
    print(cellInfo)
    titleItem = [TitleItem(id: UUID(), title: subGoalAndTaskInfo.title ?? "")]
    dueDateItem = [DueDateItem(id: UUID(), date: subGoalAndTaskInfo.dueDate)]
    memoItem = [MemoItem(id: UUID(), memo: subGoalAndTaskInfo.description)]
    completionItem = [CompletionItem(id: UUID(), isCompleted: subGoalAndTaskInfo.isCompleted)]
    
    bandalArtTitleSubject.send(subGoalAndTaskInfo.title!)
    bandalArtDueDateSubject.send(subGoalAndTaskInfo.dueDate)
    bandalArtMemoSubject.send(subGoalAndTaskInfo.description)
    bandalArtCompletionSubject.send(subGoalAndTaskInfo.isCompleted)
    
    if let mainInfo = mainInfo {
      emojiTitleItem = [EmojiTitleItem(id: UUID(), emoji: mainInfo.profileEmojiText, title: mainInfo.title)]
    }
  }
  
  struct Input {
    let didViewLoad: AnyPublisher<Void, Never>
    let themeColorSelection: AnyPublisher<IndexPath, Never>
    let deleteButtonTap: AnyPublisher<Void, Never>
    let completionButtonTap: AnyPublisher<Void, Never>
    let closeButtonTap: AnyPublisher<Void, Never>
  }
  
  struct Output {
    let completionButtonEnable: AnyPublisher<Bool, Never>
    let showDeleteAlert: AnyPublisher<Void, Never>
    let showCompleteToast: AnyPublisher<Void, Never>
    let showEmojiPopup: AnyPublisher<Void,Never>
    let dismissBottomSheet: AnyPublisher<Void,Never>
  }
  
  let emojiTitleCellViewModel = EmojiTitleCellViewModel(
    title: CurrentValueSubject<String, Never>(""),
    emoji: PassthroughSubject<Character, Never>()
  )
  let titleCellViewModel = TtleCellViewModel(
    title: CurrentValueSubject<String, Never>("")
  )
  let dueDateCellViewModel = DueDateCellViewModel(
    date: PassthroughSubject<Date, Never>(),
    resetButtonTap: PassthroughSubject<Void, Never>()
  )
  let memoCellViewModel = MemoCellViewModel(
    memo: PassthroughSubject<String, Never>()
  )
  let completionCellViewModel = CompletionCellViewModel(
    completion: CurrentValueSubject<Bool, Never>(false)
  )
  let emojiPopupViewModel = EmojiPopupViewModel(
    emojiSelection: PassthroughSubject<Character, Never>()
  )

  private let completionButtonEnableSubject = PassthroughSubject<Bool, Never>()
  private let showDeleteAlertSubject = PassthroughSubject<Void, Never>()
  private let showCompleteToastSubject = PassthroughSubject<Void, Never>()
  private let showEmojiPopupSubject = PassthroughSubject<Void, Never>()
  private let dismissBottomSheetSubject = PassthroughSubject<Void, Never>()
  
  private let bandalArtEmojiSubject = CurrentValueSubject<Character?, Never>(nil)
  private let bandalArtTitleSubject = CurrentValueSubject<String, Never>("")
  private let bandalArtThemeColorSubject = CurrentValueSubject<String, Never>("")
  private let bandalArtDueDateSubject = CurrentValueSubject<Date?, Never>(nil)
  private let bandalArtMemoSubject = CurrentValueSubject<String?, Never>(nil)
  private let bandalArtCompletionSubject = CurrentValueSubject<Bool?, Never>(nil)
  
  func transform(input: Input) -> Output {
    self.bindUseCase()
    
    emojiTitleCellViewModel.title
      .sink { [weak self] title in
        guard let self = self else { return }
        self.bandalArtTitleSubject.send(title)
      }
      .store(in: &cancellables)
    
    emojiPopupViewModel.emojiSelection
      .sink { [weak self] emoji in
        self?.emojiTitleCellViewModel.emoji
          .send(emoji)
      }
      .store(in: &cancellables)
    
    emojiTitleCellViewModel.emoji
      .sink { [weak self] emoji in
        self?.bandalArtEmojiSubject.send(emoji)
      }
      .store(in: &cancellables)
    
    titleCellViewModel.title
      .sink { [weak self] title in
        self?.bandalArtTitleSubject.send(title)
      }
      .store(in: &cancellables)

    input.themeColorSelection
      .sink { [weak self] index in
        guard let self = self else { return }
        if bandalArtCellType == .mainGoal && index.section == 1 {
          print("🕹️", index.row)
        }
      }
      .store(in: &cancellables)
    
    dueDateCellViewModel.date
      .sink { [weak self] date in
        self?.bandalArtDueDateSubject.send(date)
      }
      .store(in: &cancellables)
    
    memoCellViewModel.memo
      .sink { [weak self] memo in
        self?.bandalArtMemoSubject.send(memo)
      }
      .store(in: &cancellables)
    
    completionCellViewModel.completion
      .sink { [weak self] completion in
        self?.bandalArtCompletionSubject.send(completion)
      }
      .store(in: &cancellables)
    
    input.closeButtonTap
      .sink { [weak self] event in
        self?.dismissBottomSheetSubject.send(event)
      }
      .store(in: &cancellables)
    
    bandalArtTitleSubject
      .removeDuplicates()
      .sink { [weak self] text in
        if text.consistsOfWhitespace() {
          self?.completionButtonEnableSubject.send(false)
        } else {
          if text.count > 0 {
            self?.completionButtonEnableSubject.send(true)
          } else {
            self?.completionButtonEnableSubject.send(false)
          }
        }
        self?.titleCellViewModel.title.send(text)
      }
      .store(in: &cancellables)
    
    
    input.completionButtonTap
      .sink { [weak self] event in
        guard let self = self else { return }
        print("이모지", self.bandalArtEmojiSubject.value?.description)
        print("타이틀", self.bandalArtTitleSubject.value)
        print("메모", self.bandalArtMemoSubject.value)
        print("마감", self.bandalArtDueDateSubject.value)
        print("완료", self.bandalArtCompletionSubject.value)
        print("컬러", self.bandalArtThemeColorSubject.value)
      }
      .store(in: &cancellables)
    
    return Output(
//      title: bandalArtTitleSubject.eraseToAnyPublisher(),
//      dueDate: bandalArtDueDateSubject.eraseToAnyPublisher(),
//      memo: bandalArtMemoSubject.eraseToAnyPublisher(),
//      completion: bandalArtCompletionSubject.eraseToAnyPublisher(),
      completionButtonEnable: completionButtonEnableSubject.eraseToAnyPublisher(),
      showDeleteAlert: showDeleteAlertSubject.eraseToAnyPublisher(),
      showCompleteToast: showCompleteToastSubject.eraseToAnyPublisher(),
      showEmojiPopup: showEmojiPopupSubject.eraseToAnyPublisher(),
      dismissBottomSheet: dismissBottomSheetSubject.eraseToAnyPublisher()
    )
  }
  
  private func bindUseCase() {
    self.useCase.cellUpdateResponseStatusSubject
      .sink { [weak self] responseStatus in

      }
      .store(in: &cancellables)
  }
}

private extension ManipulateViewModel {
  func updateGoalAndTask(
    key: String = "3sF4I",
    cellKey: String = "Uvwfk"
  ) { //임시
    switch bandalArtCellType {
    case .mainGoal:
      // index to HEX
      self.useCase.updateBandalArtTask(
        key: key,
        cellKey: cellKey,
        profileEmoji: self.bandalArtEmojiSubject.value,
        title: self.bandalArtTitleSubject.value,
        description: self.bandalArtMemoSubject.value,
        dueDate: self.bandalArtDueDateSubject.value,
        mainColor: self.bandalArtThemeColorSubject.value,
        subColor: self.bandalArtThemeColorSubject.value
      )
    case .subGoal:
      self.useCase.updateBandalArtTask(
        key: key,
        cellKey: cellKey,
        title: self.bandalArtTitleSubject.value,
        description: self.bandalArtMemoSubject.value,
        dueDate: self.bandalArtDueDateSubject.value
      )
    case .task:
      switch mode {
      case .create:
        self.useCase.updateBandalArtTask(
          key: key,
          cellKey: cellKey,
          title: self.bandalArtTitleSubject.value,
          description: self.bandalArtMemoSubject.value,
          dueDate: self.bandalArtDueDateSubject.value
        )
      case .update:
        self.useCase.updateBandalArtTask(
          key: key,
          cellKey: cellKey,
          title: self.bandalArtTitleSubject.value,
          description: self.bandalArtMemoSubject.value,
          dueDate: self.bandalArtDueDateSubject.value,
          isCompleted: self.bandalArtCompletionSubject.value ?? false
        )
      }
    }
  }
}
