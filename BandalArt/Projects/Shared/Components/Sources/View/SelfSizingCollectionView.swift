//
//  SelfSizingCollectionView.swift
//  Components
//
//  Created by Sang hun Lee on 2023/08/02.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit

public class SelfSizingCollectionView: UICollectionView {
//  public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
//    super.init(frame: frame, collectionViewLayout: layout)
//    commonInit()
//  }
//
//  public required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//    commonInit()
//  }
//
//  public func commonInit() {
//    isScrollEnabled = false
//  }
//
//  public override var contentSize: CGSize {
//    didSet {
//      invalidateIntrinsicContentSize()
//    }
//  }
//
//  public override func reloadData() {
//    super.reloadData()
//    self.invalidateIntrinsicContentSize()
//  }
//
//  public override var intrinsicContentSize: CGSize {
//    return contentSize
//  }
  
  public override var contentSize:CGSize {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }

  public override var intrinsicContentSize: CGSize {
    layoutIfNeeded()
    return CGSize(width: UIView.noIntrinsicMetric, height: collectionViewLayout.collectionViewContentSize.height)
  }
}
