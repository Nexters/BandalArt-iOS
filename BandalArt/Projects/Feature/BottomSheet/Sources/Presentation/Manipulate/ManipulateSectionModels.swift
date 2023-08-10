//
//  ManipulateSectionModels.swift
//  BottomSheetFeature
//
//  Created by Sang hun Lee on 2023/08/06.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation



enum MainGoalSection: Int, CaseIterable {
  
  case emojiTitle
  case themeColor
  case dueDate
  case memo

  var title: String {
    switch self {
    case .emojiTitle:
      return "목표 이름 (필수)"
    case .themeColor:
      return "색상 테마"
    case .dueDate:
      return "마감일 (선택)"
    case .memo:
      return "메모 (선택)"
    }
  }
}

enum SubGoalAndTaskCreateSection: Int, CaseIterable {
  case title
  case dueDate
  case memo

  var title: String {
    switch self {
    case .title:
      return "목표 이름 (필수)"
    case .dueDate:
      return "마감일 (선택)"
    case .memo:
      return "메모 (선택)"
    }
  }
}

enum TaskUpdateSection: Int, CaseIterable {
  case title
  case dueDate
  case memo
  case completion

  var title: String {
    switch self {
    case .title:
      return "목표 이름 (필수)"
    case .dueDate:
      return "마감일 (선택)"
    case .memo:
      return "메모 (선택)"
    case .completion:
      return "달성 여부"
    }
  }
}
