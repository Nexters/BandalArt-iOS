//
//  BandalArtInfoResponse.swift
//  Network
//
//  Created by meng on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation

struct BandalArtInfoResponse: Decodable {
    let key: String
    let mainColor: String
    let subColor: String
    let profileEmoji: String
    let title: String
    let cellKey: String
    let dueDate: String?
    let isCompleted: Bool
    let shareKey: String?
}
