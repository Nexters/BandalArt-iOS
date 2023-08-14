//
//  ManipulateCellItemModels.swift
//  BottomSheetFeature
//
//  Created by Sang hun Lee on 2023/08/06.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit

struct EmojiTitleItem: Identifiable, Equatable {
  var id: UUID
  var emoji: Character?
  var title: String?
}

struct TitleItem: Identifiable, Equatable {
  var id: UUID
  var title: String?
}

struct ThemeColorItem: Identifiable, Equatable {
  var id: UUID
  var color: UIColor
}

struct DueDateItem: Identifiable, Equatable {
  var id: UUID
  var date: Date?
  var isOpen: Bool
}

struct MemoItem: Identifiable, Equatable {
  var id: UUID
  var memo: String?
}

struct CompletionItem: Identifiable, Equatable {
  var id: UUID
  var isCompleted: Bool?
}


