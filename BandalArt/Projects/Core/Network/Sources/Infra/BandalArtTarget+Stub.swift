//
//  BandalArtTarget+Stub.swift
//  Network
//
//  Created by Sang hun Lee on 2023/07/28.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Moya

extension BandalArtTarget {
  func stubData(_ target: BandalArtTarget) -> Data {
    switch self {
    case .getMainCell:
      return Data(
                """
                """.utf8
      )
    default:
      return Data(
                """
                """.utf8
      )
    }
  }
}
