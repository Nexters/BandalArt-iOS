//
//  BandalArtInfo.swift
//  Entity
//
//  Created by Youngmin Kim on 2023/08/06.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation

public struct BandalArtInfo {
    let title: String
    let key: String
    let mainCellKey: String
    let mainColorHexString: String
    let subColorHexString: String
    let profileEmojiText: String
    let dueDate: Date?
    let isCompleted: Bool
    let shareKey: URL?
    
    public init(title: String, key: String, mainCellKey: String,
                mainColorHexString: String, subColorHexString: String,
                profileEmojiText: String, dueDate: Date?,
                isCompleted: Bool, shareKey: URL?) {
        self.title = title
        self.key = key
        self.mainCellKey = mainCellKey
        self.mainColorHexString = mainColorHexString
        self.subColorHexString = subColorHexString
        self.profileEmojiText = profileEmojiText
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.shareKey = shareKey
    }
}
