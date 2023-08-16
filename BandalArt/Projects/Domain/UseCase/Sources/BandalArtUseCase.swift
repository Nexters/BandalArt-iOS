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
import Util

import Combine

public protocol BandalArtUseCase {
    
  var bandalArtInfoSubject: PassthroughSubject<BandalArtInfo, Never> { get }
  var bandalArtAllCellSubject: PassthroughSubject<BandalArtCellInfo, Never> { get }
  var bandalArtWebURLStringSubject: PassthroughSubject<String, Never> { get }

  var cellUpdateCompletionSubject: PassthroughSubject<Void, Never> { get }
  var errorSubject: PassthroughSubject<Void, Never> { get } // 추후 반다라트 에러에 대한 Case가 정해진다면, Void 방출이 아닌 Error 방출.
  
  /// 반다라트 생성후 조회 API (순서대로)
  func createAndFetchBandalArt()
  
  /// 반다라트 웹 공유 URL 생성 API
  func createBandalArtWebURLString(key: String)
  
  /// 반다라트 조회 API : 상세 조회 API + 메인 셀 조회 API (순서 상관 없음)
  /// - Parameters:
  ///   - key: 반다라트의 Unique Key.
  func fetchBandalArt(key: String)
    
  /**
   반다라트 삭제 API -> 반다라트 생성 API -> 반다라트 조회 API (순서대로 호출)
   - Parameters:
     - key: 반다라트의 Unique Key.
   - Note: 현재는 반다라트 추가 로직이 iOS클라 로직엔 없어서 바로 생성 API 호출하는데 ,
   추후 추가 로직이 생기면 변경될 수 있음.
  */
  func deleteAndFetchBandalArt(key: String)
  
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
  public let bandalArtWebURLStringSubject = PassthroughSubject<String, Never>()
  public let errorSubject = PassthroughSubject<Void, Never>()
  public let cellUpdateCompletionSubject = PassthroughSubject<Void, Never>()

  public init(repository: BandalArtRepository) {
    self.repository = repository
  }
  
    public func createAndFetchBandalArt() {
        if let key = UserDefaultsManager.lastUserBandalArtKey {
            self.fetchBandalArt(key: key)
            return
        }
        self.repository.postBandalArt()
            .sink(receiveCompletion: { [weak self] completion in
                self?.errorHandler(completion: completion)
                
            }, receiveValue: { [weak self] key in
                UserDefaultsManager.lastUserBandalArtKey = key
                self?.fetchBandalArt(key: key)
            })
            .store(in: &cancellables)
    }
    
    public func createBandalArtWebURLString(key: String) {
        self.repository.postWebURL(key: key)
            .sink(receiveCompletion: { [weak self] completion in
                self?.errorHandler(completion: completion)
                
            }, receiveValue: { [weak self] urlString in
                self?.bandalArtWebURLStringSubject.send(urlString)
            })
            .store(in: &cancellables)
    }
    
    public func fetchBandalArt(key: String) {
        self.repository.getBandalArtDetail(key: key)
            .zip(self.repository.getBandalArtCellList(key: key))
            .sink(receiveCompletion: { [weak self] completion in
                self?.errorHandler(completion: completion)
                
            }, receiveValue: { [weak self] info, cell in
                self?.bandalArtInfoSubject.send(info)
                self?.bandalArtAllCellSubject.send(cell)
            })
            .store(in: &cancellables)
    }
    
    public func deleteAndFetchBandalArt(key: String) {
        self.repository.deleteBandalArt(key: key)
            .flatMap { [weak self] _ -> AnyPublisher<String, BandalArtNetworkError> in
                guard let self else {
                    return Fail<String, BandalArtNetworkError>(error: .internalClientError).eraseToAnyPublisher()
                }
                return self.repository.postBandalArt()
            }
            .sink(receiveCompletion: { [weak self] completion in
                self?.errorHandler(completion: completion)
                
            }, receiveValue: { [weak self] key in
                UserDefaultsManager.lastUserBandalArtKey = key
                self?.fetchBandalArt(key: key)
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
    }, receiveValue: { [weak self] event in
      self?.cellUpdateCompletionSubject.send(event)
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
    }, receiveValue: { [weak self] event in
      self?.cellUpdateCompletionSubject.send(event)
    })
    .store(in: &cancellables)
  }
}

private extension BandalArtUseCaseImpl {
    
    /// 공통적인 에러 핸들링 함수. (현재는 Print이외에 유저에게 보여지는 에러처리는 하지 않고 있음. 추후 개선 해야함..!)
    func errorHandler(completion: Subscribers.Completion<BandalArtNetworkError>) {
        switch completion {
        case let .failure(error):
          self.errorSubject.send(())
          print("🌷 반다라트 네트워크 에러: ", error.errorDescription)
          
        case .finished: return
        }
    }
}
