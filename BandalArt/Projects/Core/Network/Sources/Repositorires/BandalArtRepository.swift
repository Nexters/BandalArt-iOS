//
//  BandalArtRepository.swift
//  Network
//
//  Created by Sang hun Lee on 2023/07/27.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Moya
import Combine

final class BandalArtRepository: BandalArtRepositoryInterface {
  let provider: MoyaProvider<BandalArtTarget>
  init() { provider = MoyaProvider<BandalArtTarget>() }
}

extension BandalArtRepository {
  
}
