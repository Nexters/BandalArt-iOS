//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by Youngmin Kim on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import UseCase
import Network

import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

public final class HomeViewModel: ViewModelType {
    
    private let useCase: BandalArtUseCase
    
    public init(
        useCase: BandalArtUseCase = BandalArtUseCaseImpl(
            repository: BandalArtRepositoryImpl()
        )
    ) {
        self.useCase = useCase
    }
    
    struct Input {
        let didViewLoad: AnyPublisher<Void, Never>
        let didMoreButtonTap: AnyPublisher<Void, Never>
        let didShareButtonTap: AnyPublisher<Void, Never>
        let didAddBarButtonTap: AnyPublisher<Void, Never>
        let didCategoryBarButtonTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let presentBandalArtAddViewController: AnyPublisher<Void, Never>
        let presentActivityViewController: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {

        return Output(
            presentBandalArtAddViewController: input.didViewLoad,
            presentActivityViewController: input.didShareButtonTap
            
        )
    }
}
