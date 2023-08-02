//
//  CircleView.swift
//  Components
//
//  Created by Sang hun Lee on 2023/08/01.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit

public final class CircleView: UIView {
  public var strokeColor: UIColor

  public init(frame: CGRect, strokeColor: UIColor) {
    self.strokeColor = strokeColor
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func setStrokeColor(color: UIColor) {
    strokeColor = color
  }

  public override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }

    let centerX = rect.size.width / 2
    let centerY = rect.size.height / 2
    let radius = min(centerX, centerY) - 1

    let circlePath = UIBezierPath(
      arcCenter: CGPoint(x: centerX, y: centerY),
      radius: radius,
      startAngle: 0,
      endAngle: CGFloat.pi * 2,
      clockwise: true
    )

    context.setLineWidth(2.0)
    strokeColor.setStroke()
    circlePath.stroke()
  }
}

public final class FilledCircleView: UIView {
  public var fillColor: UIColor

  public init(frame: CGRect, fillColor: UIColor) {
    self.fillColor = fillColor
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func setFillColor(color: UIColor) {
    fillColor = color
  }

  public override func draw(_ rect: CGRect) {
    guard UIGraphicsGetCurrentContext() != nil else { return }

    let centerX = rect.size.width / 2
    let centerY = rect.size.height / 2
    let radius: CGFloat = 17

    let circlePath = UIBezierPath(
      arcCenter: CGPoint(x: centerX, y: centerY),
      radius: radius,
      startAngle: 0,
      endAngle: CGFloat.pi * 2,
      clockwise: true
    )

    fillColor.setFill() // 내부를 채울 색상
    circlePath.fill()
  }
}
