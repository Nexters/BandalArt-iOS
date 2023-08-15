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
  
  func resize(_ width: CGFloat) -> UIImage? {
    let aspectRatio = size.width / size.height
    let newSize = CGSize(width: width, height: width / aspectRatio)
    
    let renderer = UIGraphicsImageRenderer(size: newSize)
    
    let resizedImage = renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: newSize))
    }
    
    return resizedImage
  }
}
