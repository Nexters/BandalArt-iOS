//
//  UILabel+Ex.swift
//  Components
//
//  Created by Youngmin Kim on 2023/08/19.
//  Copyright © 2023 otani. All rights reserved.
//

import UIKit.UILabel

public extension UILabel {
    
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
}
