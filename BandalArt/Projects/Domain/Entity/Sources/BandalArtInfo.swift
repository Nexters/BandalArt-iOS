//
//  BandalArtInfo.swift
//  Entity
//
//  Created by Youngmin Kim on 2023/08/06.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation

public struct BandalArtInfo {
    
    public let title: String
    public let key: String
    public let mainCellKey: String
    public let mainColorHexString: String
    public let subColorHexString: String
    public let profileEmojiText: Character
    public let dueDate: Date?
    public let isCompleted: Bool
    public let shareKey: URL?
    
    public init(title: String, key: String, mainCellKey: String,
                mainColorHexString: String, subColorHexString: String,
                profileEmojiText: Character, dueDate: Date?,
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
