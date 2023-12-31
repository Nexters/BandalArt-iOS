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
    
    private let placeHolderImageView = UIImageView(image: .init(named: "emoji.face.circle"))
    public let emojiLabel = UILabel()
    
    public var text: String? {
        return emojiLabel.text
    }
    
    public init(fontSize: CGFloat = 28,
                cornerRadius: CGFloat = 16,
                showShadow: Bool = true) {
        super.init(frame: .zero)
        setConfigure()
        setConstraints()
        
        layer.cornerRadius = cornerRadius
        emojiLabel.font = .systemFont(ofSize: fontSize)
        if showShadow { setShadow() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigure() {
        placeHolderImageView.tintColor = .gray300
        placeHolderImageView.contentMode = .center
        emojiLabel.textAlignment = .center
        backgroundColor = .gray100
    }
    
    private func setConstraints() {
        addSubview(placeHolderImageView)
        placeHolderImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(14)
        }
    }
    
    private func setShadow() {
        layer.shadowColor = UIColor(red: 0.067, green: 0.094, blue: 0.153, alpha: 0.1).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    
    /// 이모지 세팅 메소드.
    /// - Parameters:
    ///   - with: 이모지 하나 Character값. nil이면 기본 PlaceHolder 노출. 이모지만 가능..!
    public func setEmoji(with: Character?) {
        // nil이 들어올 경우 PlaceHolder 세팅 및 리턴
        guard let char = with else {
            emojiLabel.removeFromSuperview()
            placeHolderImageView.removeFromSuperview()
            addSubview(placeHolderImageView)
            placeHolderImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(14)
            }
            return
        }
        // 이모지가 아닐 경우. 디버그 에러 및 리턴.
        guard char.isEmoji else {
            assertionFailure("이모지만 넣을 수 있습니다")
            return
        }
        placeHolderImageView.removeFromSuperview()
        guard !subviews.contains(emojiLabel) else {
            emojiLabel.text = String(char)
            return
        }
        addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        emojiLabel.text = String(char)
    }
}

fileprivate extension Character {
    
    var isEmoji: Bool {
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

