//
//  GuestUseCase.swift
//  UseCase
//
//  Created by Youngmin Kim on 2023/08/15.
//  Copyright © 2023 otani. All rights reserved.
//

import Foundation
import Interface
import Entity
import Util

import Combine

public protocol GuestUseCase {
    var guestSubject: PassthroughSubject<Void, Never> { get } // 게스트 확인 완료 서브젝트
    var errorSubject: PassthroughSubject<Void, Never> { get } // 추후 반다라트 에러에 대한 Case가 정해진다면, Void 방출이 아닌 Error 방출.
    
    /// 게스트가 등록외어있지 않다면, 게스트 생성 API -> UserDefaults에 유저 키 저장.
    func registerGuestIfNeeded()
}

public class GuestUseCaseImpl: GuestUseCase {
    
    // Private
    private let repository: BandalArtRepository
    private var cancellables = Set<AnyCancellable>()
    
    public var guestSubject = PassthroughSubject<Void, Never>()
    public let errorSubject = PassthroughSubject<Void, Never>()
    
    public init(repository: BandalArtRepository) {
      self.repository = repository
    }
    
    public func registerGuestIfNeeded() {
        guard UserDefaultsManager.guestToken == nil else {
            self.guestSubject.send(())
            return
        }
        self.repository.postGuest()
            .sink(receiveCompletion: { [weak self] completion in
              switch completion {
              case let .failure(error):
                self?.errorSubject.send(())
                print("🌷 게스트 네트워크 에러: ", error.errorDescription)
                
              case .finished: return
              }
            }, receiveValue: { [weak self] guestKey in
                UserDefaultsManager.guestToken = guestKey
                self?.guestSubject.send(())
                print("👻 게스트를 생성 하였습니다")
            })
            .store(in: &cancellables)
    }
}
