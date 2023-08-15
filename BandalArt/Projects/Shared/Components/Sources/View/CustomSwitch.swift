//
//  DefaultSwitch.swift
//  Components
//
//  Created by Sang hun Lee on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import Combine

public class CustomSwitch: UIControl, ObservableObject {
  
  // MARK: Public properties
  public var animationDelay: Double = 0
  public var animationSpriteWithDamping = CGFloat(0.7)
  public var initialSpringVelocity = CGFloat(0.5)
  public var animationOptions: UIView.AnimationOptions = [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction]
  
  @Published public var isOn: Bool = false

  public var animationDuration: Double = 0.5
  public var padding: CGFloat = 1 {
    didSet {
      self.layoutSubviews()
    }
  }
  
  public var onTintColor: UIColor = UIColor(red: 144/255, green: 202/255, blue: 119/255, alpha: 1) {
    didSet {
      self.setupUI()
    }
  }
  
  public var offTintColor: UIColor = UIColor.black {
    didSet {
      self.setupUI()
    }
  }
  
  public var cornerRadius: CGFloat {
    
    get {
      return self.privateCornerRadius
    }
    set {
      if newValue > 0.5 || newValue < 0.0 {
        privateCornerRadius = 0.5
      } else {
        privateCornerRadius = newValue
      }
    }
    
  }
  
  private var privateCornerRadius: CGFloat = 0.5 {
    didSet {
      self.layoutSubviews()
    }
  }
  
  public var thumbTintColor: UIColor = UIColor.white {
    didSet {
      self.thumbView.backgroundColor = self.thumbTintColor
    }
  }
  
  public var thumbCornerRadius: CGFloat {
    get {
      return self.privateThumbCornerRadius
    }
    set {
      if newValue > 0.5 || newValue < 0.0 {
        privateThumbCornerRadius = 0.5
      } else {
        privateThumbCornerRadius = newValue
      }
    }
    
  }
  
  private var privateThumbCornerRadius: CGFloat = 0.5 {
    didSet {
      self.layoutSubviews()
      
    }
  }
  
  public var thumbSize: CGSize = CGSize.zero {
    didSet {
      self.layoutSubviews()
    }
  }
  
  public var thumbImage: UIImage? = nil {
    didSet {
      guard let image = thumbImage else {
        return
      }
      thumbView.thumbImageView.image = image
    }
  }
  
  public var onImage: UIImage? {
    didSet {
      self.onImageView.image = onImage
      self.layoutSubviews()
    }
  }
  
  public var offImage: UIImage? {
    didSet {
      self.offImageView.image = offImage
      self.layoutSubviews()
    }
  }
  
  
  public var thumbShadowColor: UIColor = UIColor.black {
    didSet {
      self.thumbView.layer.shadowColor = self.thumbShadowColor.cgColor
    }
  }
  
  public var thumbShadowOffset: CGSize = CGSize(width: 0.75, height: 2) {
    didSet {
      self.thumbView.layer.shadowOffset = self.thumbShadowOffset
    }
  }
  
  public var thumbShaddowRadius: CGFloat = 1.5 {
    didSet {
      self.thumbView.layer.shadowRadius = self.thumbShaddowRadius
    }
  }
  
  public var thumbShaddowOppacity: Float = 0.4 {
    didSet {
      self.thumbView.layer.shadowOpacity = self.thumbShaddowOppacity
    }
  }
  
  
  public var labelOff:UILabel = UILabel()
  public var labelOn:UILabel = UILabel()
  
  public var areLabelsShown: Bool = false {
    didSet {
      self.setupUI()
    }
  }
  
  public var thumbView = CustomThumbView(frame: CGRect.zero)
  public var onImageView = UIImageView(frame: CGRect.zero)
  public var offImageView = UIImageView(frame: CGRect.zero)
  public var onPoint = CGPoint.zero
  public var offPoint = CGPoint.zero
  public var isAnimating = false
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setupUI()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupUI()
  }
}

// MARK: Private methods
extension CustomSwitch {
  fileprivate func setupUI() {
    self.clear()
    
    self.clipsToBounds = false
    
    self.thumbView.backgroundColor = self.thumbTintColor
    self.thumbView.isUserInteractionEnabled = false
    
    self.thumbView.layer.shadowColor = self.thumbShadowColor.cgColor
    self.thumbView.layer.shadowRadius = self.thumbShaddowRadius
    self.thumbView.layer.shadowOpacity = self.thumbShaddowOppacity
    self.thumbView.layer.shadowOffset = self.thumbShadowOffset
    
    self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
    
    self.addSubview(self.thumbView)
    self.addSubview(self.onImageView)
    self.addSubview(self.offImageView)
    
    self.setupLabels()
  }
  
  
  private func clear() {
    for view in self.subviews {
      view.removeFromSuperview()
    }
  }
  
  override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    super.beginTracking(touch, with: event)
    
    self.animate()
    return true
  }
  
  func setOn(on:Bool, animated:Bool) {
    
    switch animated {
    case true:
      self.animate(on: on)
    case false:
      self.isOn = on
      self.setupViewsOnAction()
      self.completeAction()
    }
  }
  
  fileprivate func animate(on:Bool? = nil) {
    self.isOn = on ?? !self.isOn
    
    self.isAnimating = true
    
    UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction], animations: {
      self.setupViewsOnAction()
      
    }, completion: { _ in
      self.completeAction()
    })
  }
  
  private func setupViewsOnAction() {
    self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
    self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
    self.setOnOffImageFrame()
  }
  
  private func completeAction() {
    self.isAnimating = false
    self.sendActions(for: UIControl.Event.valueChanged)
  }
  
}

// Mark: Public methods
extension CustomSwitch {
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    if !self.isAnimating {
      self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
      self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
      
      let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width: self.bounds.size.height - 2, height: self.bounds.height - 2)
      let yPostition = (self.bounds.size.height - thumbSize.height) / 2
      
      self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
      self.offPoint = CGPoint(x: self.padding, y: yPostition)
      
      self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
      self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
      
      if self.areLabelsShown {
        let labelWidth = self.bounds.width / 2 - self.padding * 2
        self.labelOn.frame = CGRect(x: 0, y: 0, width: labelWidth, height: self.frame.height)
        self.labelOff.frame = CGRect(x: self.frame.width - labelWidth, y: 0, width: labelWidth, height: self.frame.height)
      }
      
      guard onImage != nil && offImage != nil else {
        return
      }
      
      let frameSize = thumbSize.width > thumbSize.height ? thumbSize.height * 0.7 : thumbSize.width * 0.7
      
      let onOffImageSize = CGSize(width: frameSize, height: frameSize)
      
      
      self.onImageView.frame.size = onOffImageSize
      self.offImageView.frame.size = onOffImageSize
      
      self.onImageView.center = CGPoint(x: self.onPoint.x + self.thumbView.frame.size.width / 2, y: self.thumbView.center.y)
      self.offImageView.center = CGPoint(x: self.offPoint.x + self.thumbView.frame.size.width / 2, y: self.thumbView.center.y)
      
      
      self.onImageView.alpha = self.isOn ? 1.0 : 0.0
      self.offImageView.alpha = self.isOn ? 0.0 : 1.0
      
    }
  }
}

extension CustomSwitch {
  
  fileprivate func setupLabels() {
    guard self.areLabelsShown else {
      self.labelOff.alpha = 0
      self.labelOn.alpha = 0
      return
      
    }
    
    self.labelOff.alpha = 1
    self.labelOn.alpha = 1
    
    let labelWidth = self.bounds.width / 2 - self.padding * 2
    self.labelOn.frame = CGRect(x: 0, y: 0, width: labelWidth, height: self.frame.height)
    self.labelOff.frame = CGRect(x: self.frame.width - labelWidth, y: 0, width: labelWidth, height: self.frame.height)
    self.labelOn.font = UIFont.boldSystemFont(ofSize: 12)
    self.labelOff.font = UIFont.boldSystemFont(ofSize: 12)
    self.labelOn.textColor = UIColor.white
    self.labelOff.textColor = UIColor.white
    
    self.labelOff.sizeToFit()
    self.labelOff.text = "Off"
    self.labelOn.text = "On"
    self.labelOff.textAlignment = .center
    self.labelOn.textAlignment = .center
    
    self.insertSubview(self.labelOff, belowSubview: self.thumbView)
    self.insertSubview(self.labelOn, belowSubview: self.thumbView)
  }
  
}

extension CustomSwitch {
  
  fileprivate func setOnOffImageFrame() {
    guard onImage != nil && offImage != nil else {
      return
    }
    
    self.onImageView.center.x = self.isOn ? self.onPoint.x + self.thumbView.frame.size.width / 2 : self.frame.width
    self.offImageView.center.x = !self.isOn ? self.offPoint.x + self.thumbView.frame.size.width / 2 : 0
    self.onImageView.alpha = self.isOn ? 1.0 : 0.0
    self.offImageView.alpha = self.isOn ? 0.0 : 1.0
  }
}

public final class CustomThumbView: UIView {
  fileprivate(set) var thumbImageView = UIImageView(frame: CGRect.zero)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(self.thumbImageView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.addSubview(self.thumbImageView)
  }
}

extension CustomThumbView {
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.thumbImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    self.thumbImageView.layer.cornerRadius = self.layer.cornerRadius
    self.thumbImageView.clipsToBounds = self.clipsToBounds
  }
}
