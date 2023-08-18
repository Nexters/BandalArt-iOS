//
//  BandalArtCompletedViewModel.swift
//  HomeFeature
//
//  Created by Youngmin Kim on 2023/08/19.
//  Copyright © 2023 otani. All rights reserved.
//

import Foundation
import UseCase
import Entity
import Network
import Util

import Combine

public final class BandalArtCompletedViewModel: ViewModelType {
    
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
        let didShareButtonTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let showLoading: AnyPublisher<CGFloat, Never>
        let dismissLoading: AnyPublisher<Void, Never>
        let showToast: AnyPublisher<String, Never>
        let presentActivityViewController: AnyPublisher<URL, Never>
    }
    
    private let showLoadingSubject = PassthroughSubject<CGFloat, Never>()
    private let showToastSubject = PassthroughSubject<String, Never>()
    private let dismissLoadingSubject = PassthroughSubject<Void, Never>()
    private let presentActivityViewControllerSubject = PassthroughSubject<URL, Never>()
    
    func transform(input: Input) -> Output {
        self.bindUseCase()
        
        input.didShareButtonTap
            .sink { [weak self] _ in
                self?.showLoadingSubject.send(0.5)
                self?.createBandalArtWebURLString()
            }
            .store(in: &cancellables)
        
        return Output(
            showLoading: showLoadingSubject.eraseToAnyPublisher(),
            dismissLoading: dismissLoadingSubject.eraseToAnyPublisher(),
            showToast: showToastSubject.eraseToAnyPublisher(),
            presentActivityViewController: presentActivityViewControllerSubject.eraseToAnyPublisher()
        )
    }
    
    private func bindUseCase() {
        self.useCase.errorSubject
            .sink { [weak self] _ in
                self?.dismissLoadingSubject.send(())
                self?.showToastSubject.send("네트워크 오류입니다.")
            }
            .store(in: &cancellables)
        
        self.useCase.bandalArtWebURLStringSubject
            .sink { [weak self] urlString in
                self?.dismissLoadingSubject.send(())
                guard let url = URL(string: urlString) else {
                    assertionFailure("🌷에러: URL이 잘못 들어왔어요!")
                    return
                }
                self?.presentActivityViewControllerSubject.send(url)
            }
            .store(in: &cancellables)
    }
    
    private func createBandalArtWebURLString() {
        self.useCase.createBandalArtWebURLString(key: UserDefaultsManager.lastUserBandalArtKey ?? "")
    }
}
