//
//  ManipulateViewModel.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
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
  
  public init(
      useCase: BandalArtUseCase = BandalArtUseCaseImpl(
          repository: BandalArtRepositoryImpl()
      )
  ) {
      self.useCase = useCase
  }
  
  struct Input {
    let didViewLoad: AnyPublisher<Void, Never>
    let titleTextInput: AnyPublisher<String, Never>
    let themeColotSelection: AnyPublisher<String, Never>
    let datePickerInput: AnyPublisher<Date, Never>
    let memoTextInput: AnyPublisher<String, Never>
    let deleteButtonTap: AnyPublisher<Void, Never>
    let completionButtonTap: AnyPublisher<Void, Never>
    let closeButtonTap: AnyPublisher<Void, Never>
  }
  
  struct Output {
    let completionButtonEnable: AnyPublisher<Bool, Never>
    let showDeleteAlert: AnyPublisher<Void, Never>
    let showCompleteToast: AnyPublisher<Void, Never>
    let showEmojiPopup: AnyPublisher<Void,Never>
  }
  
  private let completionButtonEnableSubject = PassthroughSubject<Bool, Never>()
  private let showDeleteAlertSubject = PassthroughSubject<Void, Never>()
  private let showCompleteToastSubject = PassthroughSubject<Void, Never>()
  private let showEmojiPopupSubject = PassthroughSubject<Void, Never>()
  
  private let bandalArtEmojiSubject = PassthroughSubject<Character, Never>()
  private let bandalArtTitleSubject = PassthroughSubject<String, Never>()
  private let bandalArtThemeColorSubject = PassthroughSubject<String, Never>()
  private let bandalArtDueDateSubject = PassthroughSubject<Date, Never>()
  private let bandalArtMemoSubject = PassthroughSubject<String, Never>()
  private let bandalArtCompletion = PassthroughSubject<Bool, Never>()
  
  
  func transform(input: Input) -> Output {
    self.bindUseCase()
    return Output(
      
      
      completionButtonEnable: completionButtonEnableSubject.eraseToAnyPublisher(),
      showDeleteAlert: showDeleteAlertSubject.eraseToAnyPublisher(),
      showCompleteToast: showCompleteToastSubject.eraseToAnyPublisher(),
      showEmojiPopup: showEmojiPopupSubject.eraseToAnyPublisher()
    )
  }
  
  private func bindUseCase() {
      
  }
}
