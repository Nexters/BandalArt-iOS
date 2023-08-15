//
//  BandalArtCreateInfoResponseDTO.swift
//  Network
//
//  Created by Youngmin Kim on 2023/08/15.
//  Copyright © 2023 otani. All rights reserved.
//

import Foundation
import Entity

struct BandalArtCreateInfoResponseDTO: Decodable {
    let id: Int
    let key: String
    let mainColor: String
    let subColor: String
    let profileEmoji: String?
}
