//
//  SubGoalAndTaskView.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit

final class PopupViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
}

extension PopupViewController: UIPopoverPresentationControllerDelegate {
  // 1
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
  
  // 2
  func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
    popoverPresentationController.containerView?.backgroundColor = .clear// UIColor.black.withAlphaComponent(0.3)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.dismiss(animated: false, completion: nil)
  }
}

extension UIViewController {
  func presentPopUp(_ button: UIView, sourceRect: CGRect) {
    // 1
    let view = PopupViewController()
    // 2
    view.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 150)
    // 3
    view.modalPresentationStyle = .popover
    // 4
    view.popoverPresentationController?.delegate = view
    // 5
    view.popoverPresentationController?.permittedArrowDirections = .up
    // 6
    view.popoverPresentationController?.sourceView = button
    // 7
    view.popoverPresentationController?.sourceRect = sourceRect
    // 8
    view.view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
    view.view.layer.shadowOpacity = 1
    view.view.layer.shadowRadius = 30
    view.view.layer.shadowOffset = CGSize(width: 0, height: -4)
    self.present(view, animated: false, completion: {
      view.view.superview?.layer.cornerRadius = 4.0
    })
  }
}
