//
//  BandalArtHomeViewController.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/19.
//

import UIKit
import BottomSheetFeature
import Components
import Entity
import Util

import CombineCocoa
import Combine
import SnapKit

public final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var cancellables = Set<AnyCancellable>()
    
    private let addButton = UIButton()
    // 반다라트 헤더
    private let emojiView = EmojiView()
    private let bandalartNameLabel = UILabel()
    private let pencilAeccessaryImageView = UIImageView(image: .init(named: "pencil.circle.filled"))
    private let moreButton = UIButton()

    private let progressDescriptionLabel = UILabel()
    private let tinyLineView = UIView()
    private let dateLabel = UILabel()
    private let progressView = UIProgressView()
    private let completedButton = UIButton()

    // 반다라트 표 컨테이너 뷰
    private let bandalartView = UIView()

    // 반다라트 표를 구성하는 뷰들
    private let centerView = UIView()
    private let centerLabel = UILabel()
    private let centerButton = UIButton()

    private let leftTopCollectionView = UICollectionView(frame: .zero,
                                                         collectionViewLayout: UICollectionViewFlowLayout.init())
    private let rightTopCollectionView = UICollectionView(frame: .zero,
                                                          collectionViewLayout: UICollectionViewFlowLayout.init())
    private let leftBottomCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: UICollectionViewFlowLayout.init())
    private let rightBottomCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: UICollectionViewFlowLayout.init())

    private let shareButton = UIButton()

    // Combine에 따로 bind가 없어서 데이터 set을 해주기위해 VC 로컬에 들고있는 상황..!
    private var leftTopInfos: [BandalArtCellInfo] = .defaultList
    private var rightTopInfos: [BandalArtCellInfo] = .defaultList
    private var leftBottomInfos: [BandalArtCellInfo] = .defaultList
    private var rightBottomInfos: [BandalArtCellInfo] = .defaultList

    private let didLoadPublisher = PassthroughSubject<Void, Never>()
    private let didCellModifyed = PassthroughSubject<Void, Never>()
    private let didDeleteButtonTap = PassthroughSubject<Void, Never>()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.setConfigure()
        self.setConstraints()
        self.bind()
    }

    @objc func moreButtonTap() {
        let actionSheet = UIAlertController(title: nil, message: nil,
                                            preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            self?.didDeleteButtonTap.send(())
        }
        let cancelAdtion = UIAlertAction(title: "취소", style: .cancel)

        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAdtion)
        self.present(actionSheet, animated: true, completion: nil)
    }

    private func bind() {
        let input = HomeViewModel.Input(
            didViewLoad: didLoadPublisher.eraseToAnyPublisher(),
            didMoreButtonTap: moreButton.tapPublisher,
            didShareButtonTap: shareButton.tapPublisher,
            didAddBarButtonTap: addButton.tapPublisher,
            didCategoryBarButtonTap: addButton.tapPublisher,
            didCellModifyed: didCellModifyed.eraseToAnyPublisher(),
            didDeleteButtonTap: didDeleteButtonTap.eraseToAnyPublisher(),
            didMainCellTap: centerButton.tapPublisher
        )
        let output = viewModel.transform(input: input)

        output.bandalArtTitle
            .sink(receiveValue: { [weak self] text in
                self?.bandalartNameLabel.text = text
                self?.bandalartNameLabel.textColor = .gray900
                self?.centerLabel.text = text
            })
            .store(in: &cancellables)

        output.bandalArtEmoji
            .sink(receiveValue: { [weak self] char in
                self?.emojiView.setEmoji(with: char)
                self?.pencilAeccessaryImageView.isHidden = true
            })
            .store(in: &cancellables)

        output.bandalArtThemeColorHexString
            .sink(receiveValue: { [weak self] main, sub in
                self?.updateTheme(main: main, sub: sub)
            })
            .store(in: &cancellables)

        output.bandalArtCompletedRatio
            .sink(receiveValue: { [weak self] ratio in
                self?.updateBandalArtRatio(ratio: ratio)
            })
            .store(in: &cancellables)

        output.bandalArtCompleted
            .removeDuplicates()
            .sink(receiveValue: { [weak self] isCompleted in
                self?.completedButton.isHidden = !isCompleted
            })
            .store(in: &cancellables)

        output.bandalArtDate
            .removeDuplicates()
            .sink(receiveValue: { [weak self] date in
                self?.dateLabel.text = "~" + date.toString
            })
            .store(in: &cancellables)

        output.bandalArtLeftTopInfo
            .sink(receiveValue: { [weak self] infos in
                self?.leftTopInfos = infos
                self?.leftTopCollectionView.reloadData()
            })
            .store(in: &cancellables)

        output.bandalArtRightTopInfo
            .sink(receiveValue: { [weak self] infos in
                self?.rightTopInfos = infos
                self?.rightTopCollectionView.reloadData()
            })
            .store(in: &cancellables)

        output.bandalArtLeftBottomInfo
            .sink(receiveValue: { [weak self] infos in
                self?.leftBottomInfos = infos
                self?.leftBottomCollectionView.reloadData()
            })
            .store(in: &cancellables)

        output.bandalArtRightBottomInfo
            .sink(receiveValue: { [weak self] infos in
                self?.rightBottomInfos = infos
                self?.rightBottomCollectionView.reloadData()
            })
            .store(in: &cancellables)

        output.presentManipulateViewController
            .sink(receiveValue: { [weak self] infos in
                self?.routeManipulateVC(type: .mainGoal, cellInfo: infos.0, info: infos.1)
            })
            .store(in: &cancellables)

        output
            .presentBandalArtAddViewController
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                let vc = BandalArtCompletedViewController(
                    title: self.bandalartNameLabel.text ?? "",
                    emojiText: self.emojiView.text
                )
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .store(in: &cancellables)

        output
            .presentActivityViewController
            .sink(receiveValue: { [weak self] _ in
                let vc = UIActivityViewController(activityItems: ["링크주데오"],
                                                  applicationActivities: nil)
                self?.present(vc, animated: true)
            })
            .store(in: &cancellables)

        didLoadPublisher.send(())
    }

    private func updateTheme(main hex1: String, sub hex2: String) {
        // 방어로직: 이전과 테마가 같으면 업데이트 안침.
        guard UIColor.themeColor != .theme(hex: hex1),
              UIColor.subThemeColor != .subTheme(hex: hex2) else {
            return
        }
        UIColor.themeColor = .theme(hex: hex1)
        UIColor.subThemeColor = .subTheme(hex: hex2)
        progressView.progressTintColor = .themeColor
        centerView.backgroundColor = .themeColor
        centerLabel.textColor = .subThemeColor
        completedButton.setTitleColor(.subThemeColor, for: .normal)
        completedButton.backgroundColor = .themeColor

        [leftTopCollectionView, leftBottomCollectionView,
         rightTopCollectionView, rightBottomCollectionView].forEach { $0.reloadData() }
    }

    private func cellInfoList(collectionView: UICollectionView) -> [BandalArtCellInfo] {
        if collectionView == leftTopCollectionView {
            return leftTopInfos
        }
        if collectionView == rightTopCollectionView {
            return rightTopInfos
        }
        if collectionView == leftBottomCollectionView {
            return leftBottomInfos
        }
        if collectionView == rightBottomCollectionView {
            return rightBottomInfos
        }
        return .defaultList
    }

    private func updateBandalArtRatio(ratio: Float) {
        let percent = Int(ratio * 100)
        self.progressDescriptionLabel.text = "달성률 (\(percent)%)"
        self.progressView.setProgress(ratio, animated: true)
    }
}

extension HomeViewController: ManipulateViewControllerDelegate {

    public func didModifyed() {
        didCellModifyed.send(())
    }
}

extension HomeViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        return UI.itemCountPerCollectionView
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BandalArtCell.identifier,
                                                            for: indexPath) as? BandalArtCell else {
            return UICollectionViewCell()
        }

        let mode: BandalArtCell.Mode = collectionView.tag == indexPath.item ? .subGoal : .task

        guard let info = self.cellInfoList(collectionView: collectionView)[safe: indexPath.item] else {
            cell.configure(title: nil, mode: mode, status: .empty)
            return cell
        }
        let isTitle = !(info.title == nil || info.title == "")
        var status: BandalArtCell.Status = isTitle ? .created : .empty
        status = info.isCompleted ? .completed : status
        cell.configure(title: info.title, mode: mode, status: status)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isLandScape = collectionView.bounds.width > collectionView.bounds.height

        let widthItemCount = isLandScape ? 3.0 : 2.0
        let heightItemCount = !isLandScape ? 3.0 : 2.0

        let widthItemSpacing: CGFloat = isLandScape ? 10 : 8
        let heightItemSpacing: CGFloat = !isLandScape ? 10 : 8

        let width = (collectionView.bounds.width - widthItemSpacing) / widthItemCount
        let height = (collectionView.bounds.height - heightItemSpacing) / heightItemCount
        return .init(width: width, height: height)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {

        guard let cellInfo = self.cellInfoList(collectionView: collectionView)[safe: indexPath.item] else { return }
        let type: BandalArtCellType = collectionView.tag == indexPath.item ? .subGoal : .task
        self.routeManipulateVC(type: type, cellInfo: cellInfo)
    }
}

// MARK: - Private func.
private extension HomeViewController {

    func routeManipulateVC(type: BandalArtCellType,
                           cellInfo: BandalArtCellInfo,
                           info: BandalArtInfo? = nil) {
        let viewController = ManipulateViewController(
          mode: .update,
          bandalArtCellType: type,
          viewModel: ManipulateViewModel(
            cellInfo: cellInfo,
            mainInfo: info,
            mode: .update,
            bandalArtCellType: type
          )
        )
        viewController.delegate = self
        viewController.preferredSheetSizing = .fit
        self.present(viewController, animated: true)
    }

    func setConfigure() {
        view.backgroundColor = .gray50

        pencilAeccessaryImageView.tintColor = .gray900
        pencilAeccessaryImageView.isUserInteractionEnabled = false
        
        bandalartNameLabel.text = "메인 목표를 입력해주세요"
        bandalartNameLabel.textColor = .gray300
        bandalartNameLabel.textAlignment = .center
        bandalartNameLabel.font = .pretendardBold(size: 20)

        moreButton.setImage(UIImage(named: "circle.triple.vertical"), for: .normal)
        moreButton.tintColor = .gray500

        progressDescriptionLabel.text = "달성률 (0%)"

        [progressDescriptionLabel, dateLabel].forEach {
            $0.textColor = .gray600
            $0.font = .pretendardMedium(size: 12)
        }

        progressView.trackTintColor = .gray100
        progressView.progressTintColor = .themeColor
        progressView.progress = 0.0

        centerView.backgroundColor = .themeColor
        centerView.layer.cornerRadius = 10

        centerLabel.numberOfLines = 3
        centerLabel.textAlignment = .center
        centerLabel.lineBreakMode = .byWordWrapping
        centerLabel.font = .pretendardBold(size: 13)

        bandalartView.backgroundColor = .clear

        tinyLineView.layer.cornerRadius = 0.5
        tinyLineView.backgroundColor = .gray300

        [leftTopCollectionView, leftBottomCollectionView, rightTopCollectionView, rightBottomCollectionView].forEach {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 12
            $0.isScrollEnabled = false
            $0.contentInset = .init(top: UI.subContentInsetValue,
                                    left: UI.subContentInsetValue,
                                    bottom: UI.subContentInsetValue,
                                    right: UI.subContentInsetValue)
            $0.register(BandalArtCell.self,
                        forCellWithReuseIdentifier: BandalArtCell.identifier)
            $0.delegate = self
            $0.dataSource = self

            if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
                layout.minimumLineSpacing = 2
                layout.minimumInteritemSpacing = 2
            }
        }

        //Tag는 서브 목표 Cell Index를 나타냄. 서브 목표의 UI구성에 사용.
        leftTopCollectionView.tag = self.viewModel.subCellIndex.0
        rightTopCollectionView.tag = self.viewModel.subCellIndex.1
        leftBottomCollectionView.tag = self.viewModel.subCellIndex.2
        rightBottomCollectionView.tag = self.viewModel.subCellIndex.3

        var config = UIButton.Configuration.plain()
        config.title = "공유하기"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .pretendardBold(size: 13)
            return outgoing
        }
        config.image = UIImage(named: "square.and.arrow.up")
        config.imagePadding = 4
        config.baseForegroundColor = .gray900
        config.baseBackgroundColor = .gray100
        config.contentInsets = .init(top: 8, leading: 16,
                                     bottom: 8, trailing: 16)
        shareButton.configuration = config
        shareButton.layer.cornerRadius = 12
        shareButton.backgroundColor = .gray100
        shareButton.layer.masksToBounds = true

        config.image = UIImage(named: "check")
        config.title = "달성 완료!"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .pretendardSemiBold(size: 11)
            return outgoing
        }
        config.contentInsets = .zero
        config.imagePadding = 2
        config.baseForegroundColor = .gray900
        completedButton.configuration = config
        completedButton.layer.cornerRadius = 12
        completedButton.backgroundColor = .themeColor
        completedButton.layer.masksToBounds = true
        completedButton.isHidden = true

        moreButton.addTarget(self, action: #selector(moreButtonTap), for: .touchUpInside)
    }

    func setConstraints() {
        view.addSubview(emojiView)
        view.addSubview(pencilAeccessaryImageView)
        view.addSubview(bandalartNameLabel)
        view.addSubview(moreButton)
        view.addSubview(progressDescriptionLabel)
        view.addSubview(tinyLineView)
        view.addSubview(dateLabel)
        view.addSubview(progressView)
        view.addSubview(completedButton)
        view.addSubview(bandalartView)
        view.addSubview(shareButton)
        centerView.addSubview(centerLabel)
        centerView.addSubview(centerButton)

        bandalartView.addSubview(centerView)
        bandalartView.addSubview(leftTopCollectionView)
        bandalartView.addSubview(rightTopCollectionView)
        bandalartView.addSubview(leftBottomCollectionView)
        bandalartView.addSubview(rightBottomCollectionView)

        shareButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
            make.centerX.equalToSuperview()
            make.width.equalTo(110)
            make.height.equalTo(36)
        }
        centerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
        emojiView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(52)
        }
        pencilAeccessaryImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.bottom.trailing.equalTo(emojiView).offset(4)
        }
        bandalartNameLabel.snp.makeConstraints { make in
            make.top.equalTo(emojiView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(44)
            make.trailing.equalToSuperview().offset(-44)
        }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(bandalartNameLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(bandalartNameLabel)
            make.width.equalTo(moreButton.snp.height)
        }
        progressDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(bandalartNameLabel.snp.bottom).offset(26)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        tinyLineView.snp.makeConstraints { make in
            make.leading.equalTo(progressDescriptionLabel.snp.trailing).offset(6)
            make.width.equalTo(1)
            make.height.equalTo(7)
            make.centerY.equalTo(progressDescriptionLabel)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(tinyLineView.snp.trailing).offset(6)
            make.centerY.equalTo(progressDescriptionLabel)
        }
        progressView.snp.makeConstraints { make in
            make.top.equalTo(progressDescriptionLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(8)
        }
        completedButton.snp.makeConstraints { make in
            make.bottom.equalTo(progressView.snp.top).offset(-6)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(24)
            make.width.equalTo(80)
        }
        bandalartView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(18)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.height.equalTo(bandalartView.snp.width)
        }
        leftTopCollectionView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(2)
            make.width.equalToSuperview().offset(-4).multipliedBy(3/5.0)
            make.height.equalToSuperview().offset(-4).multipliedBy(2/5.0)
        }
        rightTopCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalTo(leftTopCollectionView.snp.trailing).offset(2)
            make.width.equalToSuperview().offset(-4).multipliedBy(2/5.0)
            make.height.equalToSuperview().offset(-4).multipliedBy(3/5.0)
        }
        leftBottomCollectionView.snp.makeConstraints { make in
            make.top.equalTo(leftTopCollectionView.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(2)
            make.width.equalToSuperview().offset(-4).multipliedBy(2/5.0)
            make.height.equalToSuperview().offset(-4).multipliedBy(3/5.0)
        }
        rightBottomCollectionView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-2)
            make.width.equalToSuperview().offset(-4).multipliedBy(3/5.0)
            make.height.equalToSuperview().offset(-4).multipliedBy(2/5.0)
        }
        centerView.snp.makeConstraints { make in
            make.top.equalTo(leftTopCollectionView.snp.bottom).offset(2)
            make.leading.equalTo(leftBottomCollectionView.snp.trailing).offset(2)
            make.trailing.equalTo(rightTopCollectionView.snp.leading).offset(-2)
            make.bottom.equalTo(rightBottomCollectionView.snp.top).offset(-2)
        }
        centerButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setNavigationBar() {
        // set Right Navigation Item.
        var config = UIButton.Configuration.plain()
        config.title = "추가"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .pretendardBold(size: 16)
            return outgoing
        }
        config.image = UIImage(named: "plus")
        config.baseForegroundColor = .gray600
        addButton.configuration = config
        navigationItem.rightBarButtonItem = .init(customView: addButton)
        
        // set Left Navigation Item.
        let logoButton = UIButton()
        logoButton.setTitle("반다라트", for: .normal)
        logoButton.setTitleColor(.gray900, for: .normal)
        logoButton.titleLabel?.font = .neurimboGothicRelgular(size: 28)
        navigationItem.leftBarButtonItem = .init(customView: logoButton)
        navigationItem.backButtonTitle = ""
    }

    enum UI {
        static let subContentInsetValue: CGFloat = 3
        static let itemCountPerCollectionView: Int = 6
    }
}

fileprivate extension BandalArtCellInfo {

    static let defaultInfo: BandalArtCellInfo = .init(key: "", parentKey: nil, title: "",
                                                      description: nil, dueDate: nil,
                                                      isCompleted: false,
                                                      completionRatio: 0.0,
                                                      children: [])
}

fileprivate extension [BandalArtCellInfo] {

    static let defaultList: [BandalArtCellInfo] = [
        .defaultInfo, .defaultInfo, .defaultInfo,
        .defaultInfo, .defaultInfo, .defaultInfo
    ]
}
