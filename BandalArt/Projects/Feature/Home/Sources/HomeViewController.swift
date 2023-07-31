//
//  BandalArtHomeViewController.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/19.
//

import UIKit
import Components

import SnapKit

public final class HomeViewController: UIViewController {

    // 반다라트 표 컨테이너 뷰
    private let bandalartView = UIView()

    // 반다라트 표를 구성하는 뷰들
    private let centerView = UIView()
    private let centerLabel = UILabel()
    
    private let leftTopCollectionView = UICollectionView(frame: .zero,
                                                         collectionViewLayout: UICollectionViewFlowLayout.init())
    private let rightTopCollectionView = UICollectionView(frame: .zero,
                                                          collectionViewLayout: UICollectionViewFlowLayout.init())
    private let leftBottomCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: UICollectionViewFlowLayout.init())
    private let rightBottomCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private let shareButton = UIButton()

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.setConfigure()
        self.setConstraints()
        centerLabel.text = "완벽한 2024년"
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
        let status: BandalArtCell.Status = .created
        let mode: BandalArtCell.Mode = collectionView.tag == indexPath.item ? .subGoal(status) : .task(status)
        var title = "네트워킹 모임 참여"
        if case .subGoal = mode {
            title = "제테크"
        }
        cell.configure(title: title, mode: mode)
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
        print(indexPath.item)
    }
}

// MARK: - Private func.
private extension HomeViewController {
    
    @objc func addBarButtonTap() {
        print("추가하기")
    }
    
    @objc func logoBarButtonTap() {
        print("반다라트")
    }

    func setConfigure() {
        view.backgroundColor = .gray50

        centerView.backgroundColor = .mint
        centerView.layer.cornerRadius = 10
        
        centerLabel.numberOfLines = 3
        centerLabel.textAlignment = .center
        centerLabel.lineBreakMode = .byWordWrapping
        centerLabel.textColor = .gray900
        centerLabel.font = .systemFont(ofSize: 13, weight: .bold)
        
        bandalartView.backgroundColor = .clear
        
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
        leftTopCollectionView.tag = 4
        rightTopCollectionView.tag = 2
        leftBottomCollectionView.tag = 3
        rightBottomCollectionView.tag = 1
    }

    func setConstraints() {
        view.addSubview(bandalartView)
        view.addSubview(shareButton)
        centerView.addSubview(centerLabel)
        
        bandalartView.addSubview(centerView)
        bandalartView.addSubview(leftTopCollectionView)
        bandalartView.addSubview(rightTopCollectionView)
        bandalartView.addSubview(leftBottomCollectionView)
        bandalartView.addSubview(rightBottomCollectionView)

        centerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
        bandalartView.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
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
    }
    
    func setNavigationBar() {
        // set Right Navigation Item.
        var config = UIButton.Configuration.plain()
        config.title = "추가"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 16, weight: .bold)
            return outgoing
        }
        config.image = UIImage(systemName: "plus")
        config.baseForegroundColor = .gray600
        let addButton = UIButton(configuration: config)
        addButton.addTarget(self, action: #selector(addBarButtonTap),
                            for: .touchUpInside)
        navigationItem.rightBarButtonItem = .init(customView: addButton)
        
        // set Left Navigation Item.
        let logoButton = UIButton()
        logoButton.setTitle("반다라트", for: .normal)
        logoButton.setTitleColor(.gray900, for: .normal)
        logoButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .regular)
        logoButton.addTarget(self, action: #selector(logoBarButtonTap),
                             for: .touchUpInside)
        navigationItem.leftBarButtonItem = .init(customView: logoButton)
    }

    enum UI {
        static let subContentInsetValue: CGFloat = 3
        static let itemCountPerCollectionView: Int = 6
    }
}
