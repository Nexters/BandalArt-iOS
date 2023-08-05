//
//  UnderlineTextField.swift
//  Components
//
//  Created by Sang hun Lee on 2023/08/01.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit

public final class UnderlineTextField: UITextField {
  public lazy var placeholderColor: UIColor = self.tintColor
  public lazy var placeholderString: String = ""
  public lazy var padding = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
  private lazy var underlineView: UIView = {
    let lineView = UIView()
    lineView.backgroundColor = .gray300
    return lineView
  }()

  public override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(underlineView)

    underlineView.snp.makeConstraints {
      $0.top.equalTo(self.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
    }

    self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
    self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)

    self.placeholder = placeholderString
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setPlaceholder(placeholder: String, color: UIColor) {
    placeholderString = placeholder
    placeholderColor =  color

    setPlaceholder()
  }

  public override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

  public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

  public override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

  func setPlaceholder() {
    self.attributedPlaceholder = NSAttributedString(
      string: placeholderString,
      attributes: [
        NSAttributedString.Key.foregroundColor: placeholderColor
      ]
    )
  }

  func setError() {
    self.attributedPlaceholder = NSAttributedString(
      string: placeholderString,
      attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.red
      ]
    )
    underlineView.backgroundColor = .red
  }
}

extension UnderlineTextField {
  @objc func editingDidBegin() {
    setPlaceholder()
    underlineView.backgroundColor = self.tintColor
    underlineView.snp.updateConstraints {
      $0.height.equalTo(2.0)
    }
  }

  @objc func editingDidEnd() {
    underlineView.backgroundColor = placeholderColor
    underlineView.snp.updateConstraints {
      $0.height.equalTo(1.0)
    }
  }
}

