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
  
  func resize(withWidthScale scale: CGFloat) -> UIImage? {
    let originalWidth = self.size.width
    let originalHeight = self.size.height
    
    let newWidth = originalWidth * scale
    let newHeight = originalHeight * scale
    
    let newSize = CGSize(width: newWidth, height: newHeight)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
  }
}
