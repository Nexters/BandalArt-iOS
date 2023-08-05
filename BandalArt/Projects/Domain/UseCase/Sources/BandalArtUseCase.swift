//
//  BandalArtUseCase.swift
//  UseCase
//
//  Created by Youngmin Kim on 2023/08/06.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Interface

import Combine

public protocol BandalArtUseCase {
    
}

public class BandalArtUseCaseImpl: BandalArtUseCase {
    
    private let repository: BandalArtRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(repository: BandalArtRepository) {
        self.repository = repository
    }
    
    func fetchBandalArtInfo(key: String) {
        self.repository.getBandalArtDetail(key: key)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error): break
                case .finished: break
                }
            }, receiveValue: { response in
                
            })
            .store(in: &cancellables)
    }
    
    func fetchBandalArtCellList(key: String) {
        self.repository.getBandalArtCellList(key: key)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error): break
                case .finished: break
                }
            }, receiveValue: { response in
                
            })
            .store(in: &cancellables)
    }
}
