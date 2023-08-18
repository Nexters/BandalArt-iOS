//
//  BandalArtCompletedViewController.swift
//  HomeFeature
//
//  Created by Youngmin Kim on 2023/08/12.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Entity
import Components

import Combine
import Lottie
import SnapKit

final class BandalArtCompletedViewController: UIViewController {
    
    private let bandarArtTitle: String
    private let emojiText: Character?
    
    private let descriptionLabel = UILabel()
    
    private let animationView = LottieAnimationView()
    private let contentLabel = UILabel()
    private let contentView = UIView()
    private let emojiView = EmojiView()
    private let bandalartNameLabel = UILabel()
    
    private let shareButton = UIButton()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: BandalArtCompletedViewModel
    
    init(info: BandalArtInfo, viewModel: BandalArtCompletedViewModel = BandalArtCompletedViewModel()) {
        if let title = info.title {
            self.bandarArtTitle = title
        } else {
            self.bandarArtTitle = "제목 없음"
        }
        self.emojiText = info.profileEmojiText
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.setConfigure()
        self.setConstraints()
        self.bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
    private func bind() {
        let input = BandalArtCompletedViewModel.Input(
            didShareButtonTap: shareButton.tapPublisher
        )
        let output = viewModel.transform(input: input)
        
        output.showLoading
            .removeDuplicates()
            .sink(receiveValue: { alpha in
                LoadingView.startAnimatingOnWindow(alpha: alpha)
            })
            .store(in: &cancellables)
        
        output.dismissLoading
            .sink(receiveValue: { _ in
                LoadingView.stopAnimatingOnWindow()
            })
            .store(in: &cancellables)
        
        output
            .presentActivityViewController
            .sink(receiveValue: { [weak self] url in
                let vc = UIActivityViewController(activityItems: [url],
                                                  applicationActivities: nil)
                vc.excludedActivityTypes = [.addToReadingList, .assignToContact, .saveToCameraRoll, .markupAsPDF]
                self?.present(vc, animated: true)
            })
            .store(in: &cancellables)
    }
}

// MARK: - Private func.
private extension BandalArtCompletedViewController {

    func setConfigure() {
        view.backgroundColor = .gray50
        
        let animation = LottieAnimation.named("finish")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce

        descriptionLabel.text = "반다라트의 모든 목표를 달성했어요.\n정말 대단해요!"
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .gray900
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .pretendardBold(size: 22)
        
        contentLabel.text = "달성 완료 반다라트"
        contentLabel.textAlignment = .center
        contentLabel.textColor = .gray400
        contentLabel.font = .pretendardSemiBold(size: 14)
        
        bandalartNameLabel.text = bandarArtTitle
        bandalartNameLabel.textColor = .gray900
        bandalartNameLabel.textAlignment = .center
        bandalartNameLabel.font = .pretendardBold(size: 16)
        
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = UIColor.gray300.cgColor
        
        shareButton.setTitle("링크 공유하기", for: .normal)
        shareButton.setTitleColor(.systemBackground, for: .normal)
        shareButton.titleLabel?.font = .pretendardBold(size: 16)
        shareButton.layer.cornerRadius = 27.5
        shareButton.backgroundColor = .gray900
        shareButton.layer.masksToBounds = true

        emojiView.setEmoji(with: emojiText)
    }

    func setConstraints() {
        view.addSubview(descriptionLabel)
        view.addSubview(animationView)
        view.addSubview(contentLabel)
        view.addSubview(contentView)
        contentView.addSubview(emojiView)
        contentView.addSubview(bandalartNameLabel)
        view.addSubview(shareButton)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalToSuperview().inset(33)
        }
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(220)
            make.leading.trailing.equalToSuperview().inset(33)
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(33)
            make.height.equalTo(140).priority(.low)
        }
        emojiView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(48)
        }
        bandalartNameLabel.snp.makeConstraints { make in
            make.top.equalTo(emojiView.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-22)
        }
        shareButton.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.leading.trailing.equalToSuperview().inset(23)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }

    func setNavigationBar() {
        navigationItem.title = ""
    }

    enum UI {
        static let subContentInsetValue: CGFloat = 3
        static let itemCountPerCollectionView: Int = 6
    }
}
