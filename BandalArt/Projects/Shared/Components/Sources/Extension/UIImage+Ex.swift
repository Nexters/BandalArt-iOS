//
//  UIImage+Ex.swift
//  Components
//
//  Created by Sang hun Lee on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit

public extension UIImage {
  convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: (image?.cgImage)!)
  }
}
