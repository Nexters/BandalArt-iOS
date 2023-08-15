//
//  UIViewController+Ex.swift
//  Components
//
//  Created by Sang hun Lee on 2023/08/15.
//  Copyright © 2023 otani. All rights reserved.
//

import UIKit

public extension UIViewController {
  func showPopUp(title: String? = nil,
                 message: String? = nil,
                 attributedMessage: NSAttributedString? = nil,
                 leftActionTitle: String? = "취소",
                 rightActionTitle: String = "확인",
                 leftActionCompletion: (() -> Void)? = nil,
                 rightActionCompletion: (() -> Void)? = nil) {
    let popUpViewController = PopUpViewController(titleText: title,
                                                  messageText: message,
                                                  attributedMessageText: attributedMessage)
    showPopUp(popUpViewController: popUpViewController,
              leftActionTitle: leftActionTitle,
              rightActionTitle: rightActionTitle,
              leftActionCompletion: leftActionCompletion,
              rightActionCompletion: rightActionCompletion)
  }
  
  func showPopUp(contentView: UIView,
                 leftActionTitle: String? = "취소",
                 rightActionTitle: String = "확인",
                 leftActionCompletion: (() -> Void)? = nil,
                 rightActionCompletion: (() -> Void)? = nil) {
    let popUpViewController = PopUpViewController(contentView: contentView)
    
    showPopUp(popUpViewController: popUpViewController,
              leftActionTitle: leftActionTitle,
              rightActionTitle: rightActionTitle,
              leftActionCompletion: leftActionCompletion,
              rightActionCompletion: rightActionCompletion)
  }
  
  private func showPopUp(popUpViewController: PopUpViewController,
                         leftActionTitle: String?,
                         rightActionTitle: String,
                         leftActionCompletion: (() -> Void)?,
                         rightActionCompletion: (() -> Void)?) {
    popUpViewController.addActionToButton(title: leftActionTitle,
                                          titleColor: .systemGray,
                                          backgroundColor: .secondarySystemBackground) {
      popUpViewController.dismiss(animated: false, completion: leftActionCompletion)
    }
    
    popUpViewController.addActionToButton(title: rightActionTitle,
                                          titleColor: .white,
                                          backgroundColor: .gray900) {
      popUpViewController.dismiss(animated: false, completion: rightActionCompletion)
    }
    present(popUpViewController, animated: false, completion: nil)
  }
}
