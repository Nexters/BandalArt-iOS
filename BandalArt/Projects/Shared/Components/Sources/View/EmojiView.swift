//
//  EmojiView.swift
//  Components
//
//  Created by Youngmin Kim on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit

public final class EmojiView: UIView {
    
    private let placeHolderImageView = UIImageView(image: .init(systemName: "person.circle"))
    private let emojiLabel = UILabel()
    
    public init(fontSize: CGFloat = 28,
                cornerRadius: CGFloat = 16,
                showShadow: Bool = true) {
        super.init(frame: .zero)
        setDefaultUI()
        
        layer.cornerRadius = cornerRadius
        emojiLabel.font = .systemFont(ofSize: fontSize)
        if showShadow { setShadow() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDefaultUI() {
        placeHolderImageView.tintColor = .gray300
        emojiLabel.textAlignment = .center
        backgroundColor = .gray100
        addSubview(placeHolderImageView)
        placeHolderImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setShadow() {
        layer.shadowColor = UIColor(red: 0.067, green: 0.094, blue: 0.153, alpha: 0.1).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    public func setEmoji(with: Character) {
        guard with.idEmoji else {
            assertionFailure("이모지만 넣을 수 있습니다")
            return
        }
        placeHolderImageView.removeFromSuperview()
        addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        emojiLabel.text = String(with)
    }
}

fileprivate extension Character {
    
    var idEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9,
                 0x1D000...0x1F77F,
                 0x2100...0x27BF,
                 0xFE00...0xFE0F,
                 0x1F900...0x1F9FF:
                return true
                
            default: continue
            }
        }
        return false
    }
}

