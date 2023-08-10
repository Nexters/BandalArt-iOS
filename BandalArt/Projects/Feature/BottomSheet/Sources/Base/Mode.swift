//
//  Mode.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation

public enum Mode: Equatable {
  case create
  case update
}

public enum BandalArtCellType: Equatable {
  case main(cellKey: String)
  case subGoal(cellKey: String)
  case task(cellKey: String)
}
