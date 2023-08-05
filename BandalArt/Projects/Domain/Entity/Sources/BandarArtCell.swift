//
//  BandarArtCell.swift
//  Entity
//
//  Created by Youngmin Kim on 2023/08/06.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation

public struct BandalArtCell {
    
    let key: String
    let parentKey: String?
    let title: String?
    let description: String?
    let dueDate: Date?
    let isCompleted: Bool
    let completionRatio: Double
    let children: [BandalArtCell]
    
    public init(key: String, parentKey: String?, title: String?,
                description: String?, dueDate: Date?, isCompleted: Bool,
                completionRatio: Double, children: [BandalArtCell]) {
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
