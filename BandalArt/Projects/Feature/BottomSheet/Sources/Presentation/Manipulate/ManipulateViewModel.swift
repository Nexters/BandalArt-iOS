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
    
    titleItem = CurrentValueSubject<[TitleItem], Never>([TitleItem(id: UUID(), title: cellInfo.title ?? "")])
    dueDateItem = CurrentValueSubject<[DueDateItem], Never>([DueDateItem(id: UUID(), date: cellInfo.dueDate, isOpen: false)])
    memoItem = CurrentValueSubject<[MemoItem], Never>([MemoItem(id: UUID(), memo: cellInfo.description)])
    completionItem = CurrentValueSubject<[CompletionItem], Never>([CompletionItem(id: UUID(), isCompleted: cellInfo.isCompleted)])
    
    emojiTitleItem = CurrentValueSubject<[EmojiTitleItem], Never>([EmojiTitleItem(id: UUID(), emoji: mainInfo?.profileEmojiText, title: mainInfo?.title ?? "")])
    themeColorItem = CurrentValueSubject<[ThemeColorItem], Never>([
      ThemeColorItem(id: UUID(), color: .mint),
      ThemeColorItem(id: UUID(), color: .sky),
      ThemeColorItem(id: UUID(), color: .grass),
      ThemeColorItem(id: UUID(), color: .lemon),
      ThemeColorItem(id: UUID(), color: .mandarin),
      ThemeColorItem(id: UUID(), color: .pink)
    ])
    themeColorHexSubject.send(mainInfo?.mainColorHexString)
  }
  
  struct Input {
    let viewDidLoad: AnyPublisher<Void, Never>
    let themeColorSelection: AnyPublisher<IndexPath, Never>
    let deleteButtonTap: AnyPublisher<Void, Never>
    let completionButtonTap: AnyPublisher<Void, Never>
    let closeButtonTap: AnyPublisher<Void, Never>
  }
  
  struct Output {
    let titleItem: AnyPublisher<[TitleItem], Never>
    let dueDateItem: AnyPublisher<[DueDateItem], Never>
    let memoItem: AnyPublisher<[MemoItem], Never>
    let changeDueDateHeight: AnyPublisher<UUID, Never>
    
    let completionButtonEnable: AnyPublisher<Bool, Never>
    let showDeleteAlert: AnyPublisher<Void, Never>
    let showCompleteToast: AnyPublisher<Void, Never>
    let updateHomeDelegate: AnyPublisher<Void,Never>
    let selectColor: AnyPublisher<Int, Never>
    let dismissBottomSheet: AnyPublisher<Void,Never>
  }
  
  let emojiTitleCellViewModel = EmojiTitleCellViewModel(
    title: PassthroughSubject<String?, Never>(),
    emoji: PassthroughSubject<Character?, Never>()
  )
  let titleCellViewModel = TitleCellViewModel(
    title: PassthroughSubject<String?, Never>()
  )
  let dueDateCellViewModel = DueDateCellViewModel(
    date: PassthroughSubject<Date?, Never>(),
    expandButtonTap: PassthroughSubject<Void, Never>(),
    resetButtonTap: PassthroughSubject<Void, Never>()
  )
  let memoCellViewModel = MemoCellViewModel(
    memo: PassthroughSubject<String?, Never>()
  )
  let completionCellViewModel = CompletionCellViewModel(
    completion: PassthroughSubject<Bool?, Never>()
  )
  let emojiPopupViewModel = EmojiPopupViewModel(
    emojiSelection: PassthroughSubject<Character?, Never>()
  )

  var emojiTitleItem: CurrentValueSubject<[EmojiTitleItem], Never>
  var themeColorItem: CurrentValueSubject<[ThemeColorItem], Never>
  
  var titleItem: CurrentValueSubject<[TitleItem], Never>
  var dueDateItem: CurrentValueSubject<[DueDateItem], Never>
  var memoItem: CurrentValueSubject<[MemoItem], Never>
  var completionItem: CurrentValueSubject<[CompletionItem], Never>

  var changeDueDateHeight = PassthroughSubject<UUID, Never>()
  var isOpenDueDate = CurrentValueSubject<Bool, Never>(false)
  var selectColor = PassthroughSubject<Int, Never>()
  
  private let themeColorHexSubject = CurrentValueSubject<String?, Never>(nil)
  private let completionButtonEnableSubject = PassthroughSubject<Bool, Never>()
  private let showDeleteAlertSubject = PassthroughSubject<Void, Never>()
  private let showCompleteToastSubject = PassthroughSubject<Void, Never>()
  private let updateHomeDelegateSubject = PassthroughSubject<Void, Never>()
  
  private let dismissBottomSheetSubject = PassthroughSubject<Void, Never>()
  
  func transform(input: Input) -> Output {
    self.bindUseCase()
    
    input.viewDidLoad
      .sink { [weak self] _ in
        guard let self = self else { return }
        if self.bandalArtCellType == .mainGoal {
          switch self.mainGoalInfo?.mainColorHexString {
          case "#3FFFBA":
            selectColor.send(0)
          case "#3FF3FF":
            selectColor.send(1)
          case "#93FF3F":
            selectColor.send(2)
          case "#FBFF3F":
            selectColor.send(3)
          case "#FFB423":
            selectColor.send(4)
          case "#FF9DF5":
            selectColor.send(5)
          default:
            selectColor.send(0)
          }
        }
      }
      .store(in: &cancellables)
    
    emojiTitleCellViewModel.title
      .sink { [weak self] title in
        guard let self = self,
              let emojiTitleItem = emojiTitleItem.value.first else { return }
        self.emojiTitleItem.send([EmojiTitleItem(id: emojiTitleItem.id, emoji: emojiTitleItem.emoji, title: title)])
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
        guard let self = self,
              let emojiTitleItem = emojiTitleItem.value.first else { return }
        self.emojiTitleItem.send([EmojiTitleItem(id: emojiTitleItem.id, emoji: emoji, title: emojiTitleItem.title)])
      }
      .store(in: &cancellables)
    
    emojiTitleItem.removeDuplicates()
      .sink { [weak self] emojiTitleItem in
        guard let self = self,
              let text = emojiTitleItem.first?.title else { return }
        if text.consistsOfWhitespace() {
          completionButtonEnableSubject.send(false)
        } else {
          if text.count > 0 {
            completionButtonEnableSubject.send(true)
          } else {
            completionButtonEnableSubject.send(false)
          }
        }
      }
      .store(in: &cancellables)
    
    input.themeColorSelection
      .sink { [weak self] index in
        guard let self = self else { return }
        if bandalArtCellType == .mainGoal && index.section == 1 {
          switch index.row {
          case 0:
            themeColorHexSubject.send("#3FFFBA")
          case 1:
            themeColorHexSubject.send("#3FF3FF")
          case 2:
            themeColorHexSubject.send("#93FF3F")
          case 3:
            themeColorHexSubject.send("#FBFF3F")
          case 4:
            themeColorHexSubject.send("#FFB423")
          case 5:
            themeColorHexSubject.send("#FF9DF5")
          default:
            themeColorHexSubject.send("#3FFFBA")
          }
        }
      }
      .store(in: &cancellables)
    
    titleCellViewModel.title
      .sink { [weak self] title in
        guard let self = self,
              let titleItem = titleItem.value.first else { return }
        self.titleItem.send([TitleItem(id: titleItem.id, title: title)])
      }
      .store(in: &cancellables)
    
    titleItem.removeDuplicates()
      .sink { [weak self] titleItem in
        guard let self = self,
              let text = titleItem.first?.title else { return }
        if text.consistsOfWhitespace() {
          completionButtonEnableSubject.send(false)
        } else {
          if text.count > 0 {
            completionButtonEnableSubject.send(true)
          } else {
            completionButtonEnableSubject.send(false)
          }
        }
      }
      .store(in: &cancellables)
    
    dueDateCellViewModel.expandButtonTap
      .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
      .sink { [weak self] event in
        guard let self = self,
              let id = dueDateItem.value.first?.id else { return }
        changeDueDateHeight.send(id)
      }
      .store(in: &cancellables)
    
    dueDateCellViewModel.date
      .removeDuplicates()
      .sink { [weak self] date in
        guard let self = self,
              let dueDateItem = dueDateItem.value.first else { return }
        self.dueDateItem.send([DueDateItem(id: dueDateItem.id, date: date, isOpen: dueDateItem.isOpen)])
      }
      .store(in: &cancellables)
    
    isOpenDueDate
      .dropFirst()
      .sink { [weak self] state in
        guard let self = self,
              let dueDateItem = dueDateItem.value.first else { return }
        self.dueDateItem.send([DueDateItem(id: dueDateItem.id, date: dueDateItem.date, isOpen: !dueDateItem.isOpen)])
      }
      .store(in: &cancellables)
    
    memoCellViewModel.memo
      .sink { [weak self] memo in
        guard let self = self,
              let memoItem = memoItem.value.first else { return }
        self.memoItem.send([MemoItem(id: memoItem.id, memo: memo)])
      }
      .store(in: &cancellables)
    
    completionCellViewModel.completion
      .sink { [weak self] completion in
        guard let self = self,
              let completionItem = completionItem.value.first else { return }
        self.completionItem.send([CompletionItem(id: completionItem.id, isCompleted: completion)])
      }
      .store(in: &cancellables)
    
    input.closeButtonTap
      .sink { [weak self] event in
        self?.dismissBottomSheetSubject.send(event)
      }
      .store(in: &cancellables)
    
    input.completionButtonTap
      .sink { [weak self] event in
        guard let self = self else { return }
        updateGoalAndTask(cellKey: subGoalAndTaskInfo.key)
      }
      .store(in: &cancellables)
    
    input.deleteButtonTap
      .sink { [weak self] event in
        self?.showDeleteAlertSubject.send(Void())
      }
      .store(in: &cancellables)
    
    return Output(
      titleItem: titleItem.eraseToAnyPublisher(),
      dueDateItem: dueDateItem.eraseToAnyPublisher(),
      memoItem: memoItem.eraseToAnyPublisher(),
      changeDueDateHeight: changeDueDateHeight.eraseToAnyPublisher(),
      completionButtonEnable: completionButtonEnableSubject.eraseToAnyPublisher(),
      showDeleteAlert: showDeleteAlertSubject.eraseToAnyPublisher(),
      showCompleteToast: showCompleteToastSubject.eraseToAnyPublisher(),
      updateHomeDelegate: updateHomeDelegateSubject.eraseToAnyPublisher(),
      selectColor: selectColor.eraseToAnyPublisher(),
      dismissBottomSheet: dismissBottomSheetSubject.eraseToAnyPublisher()
    )
  }
  
  private func bindUseCase() {
    self.useCase.cellUpdateCompletionSubject
      .sink { [weak self] completion in
        self?.updateHomeDelegateSubject.send(Void())
        self?.dismissBottomSheetSubject.send(Void())
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
      self.useCase.updateBandalArtTask(
        key: key,
        cellKey: cellKey,
        profileEmoji: emojiTitleItem.value.first?.emoji,
        title: emojiTitleItem.value.first?.title,
        description: memoItem.value.first?.memo,
        dueDate: dueDateItem.value.first?.date,
        mainColor: themeColorHexSubject.value ?? "#3FFFBA",
        subColor: "#111827"
      )
    case .subGoal:
      self.useCase.updateBandalArtTask(
        key: key,
        cellKey: cellKey,
        title: titleItem.value.first?.title,
        description: memoItem.value.first?.memo,
        dueDate: dueDateItem.value.first?.date,
        isCompleted: nil
      )
    case .task:
      switch mode {
      case .create:
        self.useCase.updateBandalArtTask(
          key: key,
          cellKey: cellKey,
          title: titleItem.value.first?.title,
          description: memoItem.value.first?.memo,
          dueDate: dueDateItem.value.first?.date,
          isCompleted: nil
        )
      case .update:
        self.useCase.updateBandalArtTask(
          key: key,
          cellKey: cellKey,
          title: titleItem.value.first?.title,
          description: memoItem.value.first?.memo,
          dueDate: dueDateItem.value.first?.date,
          isCompleted: completionItem.value.first?.isCompleted
        )
      }
    }
  }
}
