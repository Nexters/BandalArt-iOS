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
        let showLoading: AnyPublisher<CGFloat, Never>
        let dismissLoading: AnyPublisher<Void, Never>
        let bandalArtTitle: AnyPublisher<String?, Never>
        let bandalArtEmoji: AnyPublisher<Character?, Never>
        let bandalArtThemeColorHexString: AnyPublisher<(String, String), Never>
        let bandalArtCompletedRatio: AnyPublisher<Float, Never>
        let bandalArtCompleted: AnyPublisher<Bool, Never>
        let bandalArtDate: AnyPublisher<Date?, Never>
        
        let bandalArtLeftTopInfo: AnyPublisher<[BandalArtCellInfo], Never>
        let bandalArtRightTopInfo: AnyPublisher<[BandalArtCellInfo], Never>
        let bandalArtLeftBottomInfo: AnyPublisher<[BandalArtCellInfo], Never>
        let bandalArtRightBottomInfo: AnyPublisher<[BandalArtCellInfo], Never>
        
        let presentBandalArtAddViewController: AnyPublisher<Void, Never>
        let presentActivityViewController: AnyPublisher<Void, Never>
        let presentManipulateViewController: AnyPublisher<(BandalArtCellInfo, BandalArtInfo), Never>
        let presentCompletionViewController: AnyPublisher<(Void, BandalArtInfo), Never>
    }
    
    private let showLoadingSubject = PassthroughSubject<CGFloat, Never>()
    private let dismissLoadingSubject = PassthroughSubject<Void, Never>()
    
    private let bandalArtEmojiSubject = PassthroughSubject<Character?, Never>()
    private let bandalArtTitleSubject = PassthroughSubject<String?, Never>()
    private let bandalArtCompletedRatioSubject = PassthroughSubject<Float, Never>()
    private let bandalArtThemeColorHexSubject = PassthroughSubject<(String, String), Never>()
    private let bandalArtCompletedSubject = PassthroughSubject<Bool, Never>()
    private let bandalArtDateSubject = PassthroughSubject<Date?, Never>()
    
    private let bandalArtLeftTopInfoSubject = CurrentValueSubject<[BandalArtCellInfo], Never>([])
    private let bandalArtRightTopInfoSubject = CurrentValueSubject<[BandalArtCellInfo], Never>([])
    private let bandalArtLeftBottomInfoSubject = CurrentValueSubject<[BandalArtCellInfo], Never>([])
    private let bandalArtRightBottomInfoSubject = CurrentValueSubject<[BandalArtCellInfo] , Never>([])

    private let presentManipulateViewControllerSubject = PassthroughSubject<(BandalArtCellInfo, BandalArtInfo), Never>()
    private let presentCompletionViewControllerSubject = PassthroughSubject<(Void, BandalArtInfo), Never>()

    private var mainCellInfo: BandalArtCellInfo?
    private(set) var bandalArtInfo: BandalArtInfo?
    
    // leftTop, rightTop, leftBottom, rightBottom
    var subCellIndex: (Int, Int, Int, Int) { return (4, 2, 3, 1) }
    private var canShowCompletionPage: Bool = false
    
    private let lastUserBandalArtKey = UserDefaultsManager.lastUserBandalArtKey
    
    func transform(input: Input) -> Output {
        // Use Case Binding 먼저 세팅.
        self.bindUseCase()
        
        input.didViewLoad
            .sink { [weak self] _ in
                self?.showLoadingSubject.send(1.0)
                self?.registerGuestIfNeeded()
            }
            .store(in: &cancellables)

        input.didCellModifyed
            .sink { [weak self] _ in
                self?.canShowCompletionPage = true
                self?.showLoadingSubject.send(0.5)
                self?.fetchBandalArt()
            }
            .store(in: &cancellables)

        input.didDeleteButtonTap
            .sink { [weak self] _ in
                self?.showLoadingSubject.send(0.5)
                self?.deleteBandalArt()
            }
            .store(in: &cancellables)
        
        input.didAddBarButtonTap
            .sink { [weak self] info in
                self?.showLoadingSubject.send(0.5)
                self?.fetchBandalArt()
            }
            .store(in: &cancellables)

        input.didMainCellTap
            .sink { [weak self] _ in
                guard let self, let mainCellInfo, let bandalArtInfo else { return }
                self.presentManipulateViewControllerSubject.send((mainCellInfo, bandalArtInfo))
            }
            .store(in: &cancellables)

        return Output(
            showLoading: showLoadingSubject.eraseToAnyPublisher(),
            dismissLoading: dismissLoadingSubject.eraseToAnyPublisher(),
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
            presentBandalArtAddViewController: input.didAddBarButtonTap,
            presentActivityViewController: input.didShareButtonTap,
            presentManipulateViewController: presentManipulateViewControllerSubject.eraseToAnyPublisher(),
            presentCompletionViewController: presentCompletionViewControllerSubject.eraseToAnyPublisher()
        )
    }
    
    private func bindUseCase() {
        self.guestUseCase.errorSubject
            .sink { [weak self] _ in
                self?.dismissLoadingSubject.send(())
            }
            .store(in: &cancellables)
        
        self.useCase.errorSubject
            .sink { [weak self] _ in
                self?.canShowCompletionPage = false
                self?.dismissLoadingSubject.send(())
            }
            .store(in: &cancellables)
        
        self.guestUseCase.guestSubject
            .sink { [weak self] _ in
                self?.createBandalArt()
            }
            .store(in: &cancellables)
        
        self.useCase.bandalArtInfoSubject
            .sink { [weak self] info in
                guard let self else { return }
                self.bandalArtThemeColorHexSubject.send((info.mainColorHexString, info.subColorHexString))
                self.bandalArtInfo = info
                self.bandalArtTitleSubject.send(info.title)
                self.bandalArtEmojiSubject.send(info.profileEmojiText)
                self.bandalArtCompletedSubject.send(info.isCompleted)
                self.bandalArtDateSubject.send(info.dueDate)
                
                if info.isCompleted && canShowCompletionPage { //직전에 바텀시트 수정으로 인한 완성이라면 빵빠레
                    
                }
                self.canShowCompletionPage = false
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
                self.dismissLoadingSubject.send(())
            }
            .store(in: &cancellables)
    }
}

// MARK: - UseCase Logic.
private extension HomeViewModel {
    
    func registerGuestIfNeeded() {
        self.guestUseCase.registerGuestIfNeeded()
    }
    
    func deleteBandalArt() {
        self.useCase.deleteAndFetchBandalArt(key: UserDefaultsManager.lastUserBandalArtKey ?? "")
    }
    
    func createBandalArt() {
        self.useCase.createAndFetchBandalArt()
    }
    
    func fetchBandalArt(key: String = UserDefaultsManager.lastUserBandalArtKey ?? "") { //임시
        print("🌷 반다라트 메인셀 키:", key)
        self.useCase.fetchBandalArt(key: key)
    }
}
