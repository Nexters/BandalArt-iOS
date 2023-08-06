//
//  BandalArtCellInfoResponse.swift
//  Network
//
//  Created by meng on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Entity

/// 여기서 Cell은 코드와 관련없는  반다라트 표의 한 Task를 얘기합니다.
/// 메인셀을 제외한 모든 셀
struct BandalArtCellInfoResponseDTO: Decodable {
    let key: String
    let title: String?
    let description: String?
    let dueDate: String?
    let isCompleted: Bool
    let completionRatio: Int
    let parentKey: String?
    let children: [BandalArtCellInfoResponseDTO]
}

extension BandalArtCellInfoResponseDTO {
    
    var toDomain: BandalArtCellInfo {
        return .init(key: key,
                     parentKey: parentKey,
                     title: title,
                     description: description,
                     dueDate: Date(),
                     isCompleted: isCompleted,
                     completionRatio: Float(completionRatio) / 100,
                     children: children.map { $0.toDomain }
        )
    }
}
