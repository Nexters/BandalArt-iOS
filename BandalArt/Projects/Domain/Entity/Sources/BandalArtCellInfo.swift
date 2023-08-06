//
//  BandalArtCellInfo.swift
//  Entity
//
//  Created by Youngmin Kim on 2023/08/06.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation

public struct BandalArtCellInfo {
    
    public let key: String
    public let parentKey: String?
    public let title: String?
    public let description: String?
    public let dueDate: Date?
    public let isCompleted: Bool
    public let completionRatio: Float
    public let children: [BandalArtCellInfo]
    
    public init(key: String, parentKey: String?, title: String?,
                description: String?, dueDate: Date?, isCompleted: Bool,
                completionRatio: Float, children: [BandalArtCellInfo]) {
        self.key = key
        self.parentKey = parentKey
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.completionRatio = completionRatio
        self.children = children
    }
}
