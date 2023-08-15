//
//  BandalArtUseCase.swift
//  UseCase
//
//  Created by Youngmin Kim on 2023/08/06.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Interface
import Entity

import Combine

public protocol BandalArtUseCase {
  var bandalArtInfoSubject: PassthroughSubject<BandalArtInfo, Never> { get }
  var bandalArtAllCellSubject: PassthroughSubject<BandalArtCellInfo, Never> { get }
  var cellUpdateResponseStatusSubject: PassthroughSubject<Int, Never> { get }
  var errorSubject: PassthroughSubject<Void, Never> { get }

  /// 반다라트 조회 API : 상세 조회 API + 메인 셀 조회 API (순서 상관 없음)
  /// - Parameters:
  ///   - key: 반다라트의 Unique Key.
  func fetchBandalArt(key: String)

  /// mainGoal 수정 API : profileEmoji, mainColor, subColor 포함
  /// - Parameters:
  ///   - key: 반다라트의 Unique Key.
  func updateBandalArtTask(key: String,
                           cellKey: String,
                           profileEmoji: Character?,
                           title: String?,
                           description: String?,
                           dueDate: Date?,
                           mainColor: String,
                           subColor: String)

  func updateBandalArtTask(key: String,
                           cellKey: String,
                           title: String?,
                           description: String?,
                           dueDate: Date?,
                           isCompleted: Bool?)
}

public class BandalArtUseCaseImpl: BandalArtUseCase {

  // Private
  private let repository: BandalArtRepository
  private var cancellables = Set<AnyCancellable>()

  // Public (뷰모델에서 바인딩에 사용)
  public let bandalArtInfoSubject = PassthroughSubject<BandalArtInfo, Never>()
  public let bandalArtAllCellSubject = PassthroughSubject<BandalArtCellInfo, Never>()
  public let errorSubject = PassthroughSubject<Void, Never>()
  public let cellUpdateResponseStatusSubject = PassthroughSubject<Int, Never>()

  public init(repository: BandalArtRepository) {
    self.repository = repository
  }

  public func fetchBandalArt(key: String) {
    self.repository.getBandalArtDetail(key: key)
      .zip(self.repository.getBandalArtCellList(key: key))
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case let .failure(error): // 추후 반다라트 에러에 대한 Case가 정해진다면, Void 방출이 아닌 Error 방출.
          self?.errorSubject.send(())
          print("네트워크 에러: ", error.errorDescription)

        case .finished: return
        }
      }, receiveValue: { [weak self] info, cell in
        self?.bandalArtInfoSubject.send(info)
        self?.bandalArtAllCellSubject.send(cell)
      })
      .store(in: &cancellables)
  }

  public func updateBandalArtTask(
    key: String,
    cellKey: String,
    profileEmoji: Character? = nil,
    title: String?,
    description: String? = nil,
    dueDate: Date? = nil,
    mainColor: String,
    subColor: String
  ) {
    self.repository.postTaskUpdateData(
      key: key,
      cellKey: cellKey,
      profileEmoji: profileEmoji,
      title: title,
      description: description,
      dueDate: dueDate,
      mainColor: mainColor,
      subColor: subColor
    ).sink(receiveCompletion: { [weak self] completion in
      switch completion {
      case let .failure(error):
        // 추후 반다라트 에러에 대한 Case가 정해진다면, Void 방출이 아닌 Error 방출.
        self?.errorSubject.send(())
        print(error)
      case .finished: return
      }
    }, receiveValue: { [weak self] response in
      self?.cellUpdateResponseStatusSubject.send(response.statusCode)
    })
    .store(in: &cancellables)
  }

  public func updateBandalArtTask(
    key: String,
    cellKey: String,
    title: String?,
    description: String?,
    dueDate: Date?,
    isCompleted: Bool? = nil
  ) {
    self.repository.postTaskUpdateData(
      key: key,
      cellKey: cellKey,
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: isCompleted
    ).sink(receiveCompletion: { [weak self] completion in
      switch completion {
      case let .failure(error):
        // 추후 반다라트 에러에 대한 Case가 정해진다면, Void 방출이 아닌 Error 방출.
        self?.errorSubject.send(())
        print(error)
      case .finished: return
      }
    }, receiveValue: { [weak self] response in
      self?.cellUpdateResponseStatusSubject.send(response.statusCode)
    })
    .store(in: &cancellables)
  }
}

