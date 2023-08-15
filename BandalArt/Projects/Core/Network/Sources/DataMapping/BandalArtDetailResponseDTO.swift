//
//  BandalArtDetailResponseDTO.swift
//  Network
//
//  Created by meng on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Entity
import Util

struct BandalArtDetailResponseDTO: Decodable {
    let key: String
    let mainColor: String
    let subColor: String
    let profileEmoji: String?
    let title: String?
    let cellKey: String
    let dueDate: Date?
    let isCompleted: Bool
    let shareKey: String?
}

extension BandalArtDetailResponseDTO {
    
    var toDomain: BandalArtInfo {
        return .init(title: title,
                     key: key,
                     mainCellKey: cellKey,
                     mainColorHexString: mainColor,
                     subColorHexString: subColor,
                     profileEmojiText: profileEmoji.toChar,
                     dueDate: dueDate,
                     isCompleted: isCompleted,
                     shareKey: URL(string: shareKey ?? ""))
    }
}
