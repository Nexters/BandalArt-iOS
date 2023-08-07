//
//  MainGoalCellItemModels.swift
//  BottomSheetFeature
//
//  Created by Sang hun Lee on 2023/08/06.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit

struct EmojiTitleItem: Identifiable {
  var id: UUID
  var emoji: Character?
  var title: String
}

struct TitleItem: Identifiable {
  var id: UUID
  var title: String
}

struct ThemeColorItem: Identifiable {
  var id: UUID
  var color: UIColor
}

struct DueDateItem: Identifiable {
  var id: UUID
  var date: Date
}

struct MemoItem: Identifiable {
  var id: UUID
  var memo: String
}

struct CompletionItem: Identifiable {
  var id: UUID
  var isCompleted: Bool
}


