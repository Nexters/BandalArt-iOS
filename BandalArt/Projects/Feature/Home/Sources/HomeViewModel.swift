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
    
    private let guestUseCase: GuestUseCase = GuestUseCaseImpl(repository: BandalArtRepositoryImpl()) // 온보딩 전까지 임시
    
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
        let didCellModifyed: AnyPublisher<Void, Never> // 현재는 이 인풋 오면 싹다 업데이트
        let didDeleteButtonTap: AnyPublisher<Void, Never>
        let didMainCellTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let bandalArtTitle: AnyPublisher<String, Never>
        let bandalArtEmoji: AnyPublisher<Character, Never>
        let bandalArtThemeColorHexString: AnyPublisher<(String, String), Never>
        let bandalArtCompletedRatio: AnyPublisher<Float, Never>
        let bandalArtCompleted: AnyPublisher<Bool, Never>
        let bandalArtDate: AnyPublisher<Date, Never>
        
        let bandalArtLeftTopInfo: AnyPublisher<[BandalArtCellInfo], Never>
        let bandalArtRightTopInfo: AnyPublisher<[BandalArtCellInfo], Never>
        let bandalArtLeftBottomInfo: AnyPublisher<[BandalArtCellInfo], Never>
        let bandalArtRightBottomInfo: AnyPublisher<[BandalArtCellInfo], Never>
        
        let presentBandalArtAddViewController: AnyPublisher<Void, Never>
        let presentActivityViewController: AnyPublisher<Void, Never>
        let presentManipulateViewController: AnyPublisher<(BandalArtCellInfo, BandalArtInfo?), Never>
    }
    
    private let bandalArtEmojiSubject = PassthroughSubject<Character, Never>()
    private let bandalArtTitleSubject = PassthroughSubject<String, Never>()
    private let bandalArtCompletedRatioSubject = PassthroughSubject<Float, Never>()
    private let bandalArtThemeColorHexSubject = PassthroughSubject<(String, String), Never>()
    private let bandalArtCompletedSubject = PassthroughSubject<Bool, Never>()
    private let bandalArtDateSubject = PassthroughSubject<Date, Never>()
    
    private let bandalArtLeftTopInfoSubject = CurrentValueSubject<[BandalArtCellInfo], Never>([])
    private let bandalArtRightTopInfoSubject = CurrentValueSubject<[BandalArtCellInfo], Never>([])
    private let bandalArtLeftBottomInfoSubject = CurrentValueSubject<[BandalArtCellInfo], Never>([])
    private let bandalArtRightBottomInfoSubject = CurrentValueSubject<[BandalArtCellInfo] , Never>([])

    private let presentManipulateViewControllerSubject = PassthroughSubject<(BandalArtCellInfo, BandalArtInfo?), Never>()


    private var mainCellInfo: BandalArtCellInfo?
    private var bandalArtInfo: BandalArtInfo?
    
    // leftTop, rightTop, leftBottom, rightBottom
    var subCellIndex: (Int, Int, Int, Int) { return (4, 2, 3, 1) }
    
    private let lastUserBandalArtKey = UserDefaultsManager.lastUserBandalArtKey
    
    func transform(input: Input) -> Output {
        // Use Case Binding 먼저 세팅.
        self.bindUseCase()
        
        input.didViewLoad
            .sink { [weak self] _ in
                self?.registerGuestIfNeeded()
            }
            .store(in: &cancellables)

        input.didCellModifyed
            .sink { [weak self] _ in
                self?.fetchBandalArt()
            }
            .store(in: &cancellables)

        input.didDeleteButtonTap
            .sink { [weak self] _ in
                print("삭제 버튼 누름!!")
                // 삭제 API
            }
            .store(in: &cancellables)
        
        input.didAddBarButtonTap
            .sink { [weak self] info in
                self?.fetchBandalArt()
            }
            .store(in: &cancellables)

        input.didMainCellTap
            .sink { [weak self] _ in
                guard let self, let mainCellInfo else { return }
                self.presentManipulateViewControllerSubject.send((mainCellInfo, self.bandalArtInfo))
            }
            .store(in: &cancellables)

        return Output(
            bandalArtTitle: bandalArtTitleSubject.eraseToAnyPublisher(),
            bandalArtEmoji: bandalArtEmojiSubject.eraseToAnyPublisher(),
            bandalArtThemeColorHexString: bandalArtThemeColorHexSubject.eraseToAnyPublisher(),
            bandalArtCompletedRatio: bandalArtCompletedRatioSubject.eraseToAnyPublisher(),
            bandalArtCompleted: bandalArtCompletedSubject.eraseToAnyPublisher(),
            bandalArtDate: bandalArtDateSubject.eraseToAnyPublisher(),
            bandalArtLeftTopInfo: bandalArtLeftTopInfoSubject.eraseToAnyPublisher(),
            bandalArtRightTopInfo: bandalArtRightTopInfoSubject.eraseToAnyPublisher(),
            bandalArtLeftBottomInfo: bandalArtLeftBottomInfoSubject.eraseToAnyPublisher(),
            bandalArtRightBottomInfo: bandalArtRightBottomInfoSubject.eraseToAnyPublisher(),
            presentBandalArtAddViewController: input.didShareButtonTap,
            presentActivityViewController: input.didShareButtonTap,
            presentManipulateViewController: presentManipulateViewControllerSubject.eraseToAnyPublisher()
        )
    }
    
    private func bindUseCase() {
        self.guestUseCase.guestSubject
            .sink { [weak self] _ in
                self?.createBandalArt()
            }
            .store(in: &cancellables)
        
        self.useCase.bandalArtInfoSubject
            .sink { [weak self] info in
                self?.bandalArtInfo = info
                self?.bandalArtTitleSubject.send(info.title)
                self?.bandalArtEmojiSubject.send(info.profileEmojiText)
                self?.bandalArtThemeColorHexSubject.send((info.mainColorHexString, info.subColorHexString))
                self?.bandalArtCompletedSubject.send(info.isCompleted)
                self?.bandalArtDateSubject.send(info.dueDate ?? Date())

            }
            .store(in: &cancellables)
        
        self.useCase.bandalArtAllCellSubject
            .sink { [weak self] mainCell in
                guard let self else { return }
                self.mainCellInfo = mainCell
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
    
    func registerGuestIfNeeded() {
        self.guestUseCase.registerGuestIfNeeded()
    }
    
    func createBandalArt() {
        self.useCase.createAndFetchBandalArt()
    }
    
    func fetchBandalArt(key: String = UserDefaultsManager.lastUserBandalArtKey ?? "") { //임시
        self.useCase.fetchBandalArt(key: key)
    }
}
