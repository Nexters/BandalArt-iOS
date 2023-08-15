//
//  UIColor+Ex.swift
//  Components
//
//  Created by Youngmin Kim on 2023/07/31.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit.UIColor

public extension UIColor {
    static var themeColor: UIColor = .lemon
    static var subThemeColor: UIColor = .lightGrape
}

public extension UIColor {
    
    static var mint: UIColor {
        return UIColor(named: AppColorCase.mint.rawValue)!
    }
    static var grass: UIColor {
        return UIColor(named: AppColorCase.grass.rawValue)!
    }
    static var lemon: UIColor {
        return UIColor(named: AppColorCase.lemon.rawValue)!
    }
    static var mandarin: UIColor {
        return UIColor(named: AppColorCase.mandarin.rawValue)!
    }
    static var grape: UIColor {
        return UIColor(named: AppColorCase.grape.rawValue)!
    }
    static var sky: UIColor {
        return UIColor(named: AppColorCase.sky.rawValue)!
    }
    static var pink: UIColor {
      return UIColor(named: AppColorCase.pink.rawValue)!
    }
    static var darkNavy: UIColor {
        return UIColor(named: AppColorCase.darkNavy.rawValue)!
    }
    static var lightGrape: UIColor {
        return UIColor(named: AppColorCase.lightGrape.rawValue)!
    }
    static var gray50: UIColor {
        return UIColor(named: AppColorCase.gray50.rawValue)!
    }
    static var gray100: UIColor {
        return UIColor(named: AppColorCase.gray100.rawValue)!
    }
    static var gray200: UIColor {
        return UIColor(named: AppColorCase.gray200.rawValue)!
    }
    static var gray300: UIColor {
        return UIColor(named: AppColorCase.gray300.rawValue)!
    }
    static var gray400: UIColor {
        return UIColor(named: AppColorCase.gray400.rawValue)!
    }
    static var gray500: UIColor {
        return UIColor(named: AppColorCase.gray500.rawValue)!
    }
    static var gray600: UIColor {
        return UIColor(named: AppColorCase.gray600.rawValue)!
    }
    static var gray700: UIColor {
        return UIColor(named: AppColorCase.gray700.rawValue)!
    }
    static var gray800: UIColor {
        return UIColor(named: AppColorCase.gray800.rawValue)!
    }
    static var gray900: UIColor {
        return UIColor(named: AppColorCase.gray900.rawValue)!
    }
}
 
// MARK: - Theme, SubTheme Color
public extension UIColor {
    
    static var themeColorList: [UIColor] {
        return [.mint, .sky, .grass, .lemon, .mandarin, .pink]
    }
    
    static var subThemeColorList: [UIColor] {
        return [.lightGrape, .darkNavy]
    }
    
    /// 테마 찾기 메소드.
    /// - Parameters:
    ///   - hex: #가 포함된 컬러의 HexString 값 ex. #142424
    /// - Returns: UIColor. 찾는 Hex에 대한 테마값이 없다면 디폴트로 mint 컬러 리턴.
    static func theme(hex: String) -> UIColor {
        return .themeColorList.first { $0.hexString == hex} ?? .lemon
    }
    
    /// 서브 테마 찾기 메소드.
    /// - Parameters:
    ///   - hex: #가 포함된 컬러의 HexString 값 ex. #142424
    /// - Returns: `UIColor`.  찾는 Hex에 대한 테마값이 없다면 디폴트로 darkNavy 컬러 리턴.
    static func subTheme(hex: String) -> UIColor {
        return .subThemeColorList.first { $0.hexString == hex} ?? .lightGrape
    }
}

// MARK: - Converting HexString <=> UIColor
fileprivate extension UIColor {
    
    var hexString: String? {
        guard let components = self.cgColor.components else { return nil }

        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
    }
}
