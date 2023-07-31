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
        case task(Status)
        case subGoal(Status)
        
        var backGroundColor: UIColor {
            switch self {
            case .task: return .systemBackground
            case .subGoal: return .gray900
            }
        }
        
        var font: UIFont {
            switch self {
            case .task: return .systemFont(ofSize: 12, weight: .medium)
            case .subGoal: return .systemFont(ofSize: 13, weight: .bold)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .task: return .gray900
            case .subGoal: return .mint
            }
        }
    }

    static let identifier: String = "BasicCell"

    private let descriptionLabel = UILabel()

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
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
    }

    func configure(title: String?, mode: Mode) {
        descriptionLabel.text = title
        contentView.backgroundColor = mode.backGroundColor
        descriptionLabel.font = mode.font
        descriptionLabel.textColor = mode.textColor
    }
}
