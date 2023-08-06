//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by Youngmin Kim on 2023/07/31.
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

public final class HomeViewModel: ViewModelType {
    
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
        let didMoreButtonTap: AnyPublisher<Void, Never>
        let didShareButtonTap: AnyPublisher<Void, Never>
        let didAddBarButtonTap: AnyPublisher<Void, Never>
        let didCategoryBarButtonTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let bandalArtTitle: AnyPublisher<String, Never>
        let bandalArtEmoji: AnyPublisher<String, Never>
        let bandalArtThemeColorHexString: AnyPublisher<(String, String), Never>
        let bandalArtCompletedRatio: AnyPublisher<Float, Never>
        
        let bandalArtLeftTopInfo: AnyPublisher<[BandalArtCellInfo], Never>
        let bandalArtRightTopInfo: AnyPublisher<[BandalArtCellInfo], Never>
        let bandalArtLeftBottomInfo: AnyPublisher<[BandalArtCellInfo], Never>
        let bandalArtRightBottomInfo: AnyPublisher<[BandalArtCellInfo], Never>
        
        let presentBandalArtAddViewController: AnyPublisher<Void, Never>
        let presentActivityViewController: AnyPublisher<Void, Never>
    }
    
    private let bandalArtEmojiSubject = PassthroughSubject<String, Never>()
    private let bandalArtTitleSubject = PassthroughSubject<String, Never>()
    private let bandalArtCompletedRatioSubject = PassthroughSubject<Float, Never>()
    private let bandalArtThemeColorHexSubject = PassthroughSubject<(String, String), Never>()
    
    private let bandalArtLeftTopInfoSubject = PassthroughSubject<[BandalArtCellInfo], Never>()
    private let bandalArtRightTopInfoSubject = PassthroughSubject<[BandalArtCellInfo], Never>()
    private let bandalArtLeftBottomInfoSubject = PassthroughSubject<[BandalArtCellInfo], Never>()
    private let bandalArtRightBottomInfoSubject = PassthroughSubject<[BandalArtCellInfo] , Never>()
    
    // leftTop, rightTop, leftBottom, rightBottom
    var subCellIndex: (Int, Int, Int, Int) { return (4, 2, 3, 1) }
    
    func transform(input: Input) -> Output {
        // Use Case Binding 먼저 세팅.
        self.bindUseCase()
        
        input.didViewLoad
            .sink { [weak self] _ in
                self?.fetchBandalArt()
            }
            .store(in: &cancellables)
        
//        input.didAddBarButtonTap
//            .sink { info in
//                <#code#>
//            }
//            .store(in: &cancellables)

        return Output(
            bandalArtTitle: bandalArtTitleSubject.eraseToAnyPublisher(),
            bandalArtEmoji: bandalArtEmojiSubject.eraseToAnyPublisher(),
            bandalArtThemeColorHexString: bandalArtThemeColorHexSubject.eraseToAnyPublisher(),
            bandalArtCompletedRatio: bandalArtCompletedRatioSubject.eraseToAnyPublisher(),
            bandalArtLeftTopInfo: bandalArtLeftTopInfoSubject.eraseToAnyPublisher(),
            bandalArtRightTopInfo: bandalArtRightTopInfoSubject.eraseToAnyPublisher(),
            bandalArtLeftBottomInfo: bandalArtLeftBottomInfoSubject.eraseToAnyPublisher(),
            bandalArtRightBottomInfo: bandalArtRightBottomInfoSubject.eraseToAnyPublisher(),
            presentBandalArtAddViewController: input.didViewLoad,
            presentActivityViewController: input.didShareButtonTap
        )
    }
    
    private func bindUseCase() {
        self.useCase.bandalArtInfoSubject
            .sink { [weak self] info in
                self?.bandalArtTitleSubject.send(info.title)
                self?.bandalArtEmojiSubject.send(info.profileEmojiText)
                self?.bandalArtThemeColorHexSubject.send((info.mainColorHexString, info.subColorHexString))
            }
            .store(in: &cancellables)
        
        self.useCase.bandalArtAllCellSubject
            .sink { [weak self] mainCell in
                guard let self else { return }
                self.bandalArtCompletedRatioSubject.send(mainCell.completionRatio)

                if let leftTop = mainCell.children[safe: 0] {
                    var list = leftTop.children
                    list.insert(leftTop, at: self.subCellIndex.0)
                    self.bandalArtLeftTopInfoSubject.send(list)
                }
                
                if let rightTop = mainCell.children[safe: 1] {
                    var list = rightTop.children
                    list.insert(rightTop, at: self.subCellIndex.1)
                    self.bandalArtRightTopInfoSubject.send(list)
                }
                
                if let leftBottom = mainCell.children[safe: 2] {
                    var list = leftBottom.children
                    list.insert(leftBottom, at: self.subCellIndex.2)
                    self.bandalArtLeftBottomInfoSubject.send(list)
                }
                
                if let rightBottom = mainCell.children[safe: 3] {
                    var list = rightBottom.children
                    list.insert(rightBottom, at: self.subCellIndex.3)
                    self.bandalArtRightBottomInfoSubject.send(list)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UseCase Logic.
private extension HomeViewModel {
    
    func fetchBandalArt(key: String = "3sF4I") { //임시
        self.useCase.fetchBandalArt(key: key)
    }
}
