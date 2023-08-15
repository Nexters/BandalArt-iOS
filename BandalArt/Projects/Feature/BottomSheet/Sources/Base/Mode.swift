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
  case mainGoal
  case subGoal
  case task
  
  var title: String {
    switch self {
    case .mainGoal:
      return "메인목표"
    case .subGoal:
      return "서브목표"
    case .task:
      return "태스크"
    }
  }
  
  var message: String {
    switch self {
    case .mainGoal:
      return "서브목표와 태스크들이 모두 삭제돼요"
    case .subGoal:
      return "속해있는 하위 태스크들이 모두 삭제돼요"
    case .task:
      return "해당 태스크만 삭제돼요"
    }
  }
}
