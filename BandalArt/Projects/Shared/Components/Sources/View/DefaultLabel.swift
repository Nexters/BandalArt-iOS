//
//  DefaultLabel.swift
//  Components
//
//  Created by Sang hun Lee on 2023/08/02.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit.UILabel

public final class DefaultLabel: UILabel {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.setConfiguration()
  }
  
  public convenience init(font: UIFont) {
    self.init()
    self.font = font
  }
  
  public convenience init(font: UIFont, textColor: UIColor = .label) {
    self.init()
    self.font = font
    self.textColor = textColor
    self.textAlignment = .center
  }
  
  public convenience init(title text: String, font: UIFont, textColor: UIColor = .label) {
    self.init()
    self.text = text
    self.font = font
    self.textColor = textColor
    self.textAlignment = .center
  }
  
  public convenience init(title text: String, font: UIFont, textColor: UIColor = .label, backgroundColor: UIColor = .systemBackground, textAlignment: NSTextAlignment) {
    self.init()
    self.text = text
    self.font = font
    self.textColor = textColor
    self.textAlignment = textAlignment
    self.backgroundColor = backgroundColor
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("DefaultFillButton: fatal Error Message")
  }
  
  private func setConfiguration() {
    numberOfLines = 0
  }
}
