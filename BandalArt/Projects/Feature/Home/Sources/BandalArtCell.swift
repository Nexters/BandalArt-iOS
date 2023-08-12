//
//  BandalArtCell.swift
//  HomeFeature
//
//  Created by Youngmin Kim on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Components

final class BandalArtCell: UICollectionViewCell {
    
    enum Status {
        /// 작성 전
        case empty
        /// 작성 후
        case created
        /// 목표 달성
        case completed
    }
    
    enum Mode: Equatable {
        case task
        case subGoal
        
        var backGroundColor: UIColor {
            switch self {
            case .task: return .systemBackground
            case .subGoal: return .subThemeColor
            }
        }
        
        var font: UIFont {
            switch self {
            case .task: return .pretendardMedium(size: 12)
            case .subGoal: return .pretendardBold(size: 13)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .task: return .gray900
            case .subGoal: return .themeColor
            }
        }
    }

    static let identifier: String = "BasicCell"

    //작성 전 컴포넌트
    private let placeHolderView = BandalartPlaceHolderView()
    
    //작성 후 컴포넌트
    private let descriptionLabel = UILabel()
    
    //완료 후 컴포넌트
    private let completionView = BandalartCompletionView()
    
    var mode: Mode = .task

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .systemBackground
        
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .center
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textColor = .gray900
        descriptionLabel.font = .pretendardMedium(size: 12)
        
        contentView.addSubview(placeHolderView)
        placeHolderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }


    func configure(title: String?, mode: Mode, status: Status) {
        contentView.backgroundColor = mode.backGroundColor
        self.mode = mode
        
        switch status {
        case .empty:
            descriptionLabel.removeFromSuperview()
            placeHolderView.configure(mode: mode)
            
        case .created, .completed:
            placeHolderView.removeFromSuperview()
            contentView.addSubview(descriptionLabel)
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(6)
                make.bottom.equalToSuperview().offset(-6)
                make.leading.equalToSuperview().offset(5)
                make.trailing.equalToSuperview().offset(-5)
            }
            descriptionLabel.text = title
            descriptionLabel.font = mode.font
            descriptionLabel.textColor = mode.textColor
        }
        
        guard status == .completed else { return }
        setCompleted()
    }
    
    func setCompleted() {
        if mode == .task {
            contentView.backgroundColor = .gray300
        }
        contentView.addSubview(completionView)
        completionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        completionView.setCheckImageHidden(mode == .subGoal)
    }
}

final class BandalartCompletionView: UIView {
    
    private let checkImageView = UIImageView(image: .init(named: "check.circle.filled"))
    
    public init() {
        super.init(frame: .zero)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        checkImageView.tintColor = .gray500
        layer.cornerRadius = 10
        backgroundColor = .systemBackground.withAlphaComponent(0.6)
        checkImageView.backgroundColor = .clear
        
        addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(-2)
            make.width.height.equalTo(22)
        }
    }
    
    func setCheckImageHidden(_ isHidden: Bool) {
        checkImageView.isHidden = isHidden
    }
}

final class BandalartPlaceHolderView: UIView {
    
    private let stackView = UIStackView()
    private let plusImageView = UIImageView(image: .init(named: "plus"))
    
    public init() {
        super.init(frame: .zero)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .clear
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        plusImageView.tintColor = .gray500
        plusImageView.contentMode = .center
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.bottom.trailing.equalToSuperview().offset(-12)
        }
        stackView.addArrangedSubview(plusImageView)
    }
    
    func configure(mode: BandalArtCell.Mode) {
        self.plusImageView.tintColor = mode.textColor
        
        guard mode == .subGoal else { return }
        let label = UILabel()
        label.textAlignment = .center
        label.font = .pretendardBold(size: 12)
        label.text = "서브목표"
        label.textColor = mode.textColor
        stackView.insertArrangedSubview(label, at: 0)
    }
}
