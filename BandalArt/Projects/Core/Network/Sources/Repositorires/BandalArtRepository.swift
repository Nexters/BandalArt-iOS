//
//  BandalArtRepository.swift
//  Network
//
//  Created by Sang hun Lee on 2023/07/27.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Combine
import CombineMoya
import Moya

final class BandalArtRepository: BandalArtRepositoryInterface {
  private let provider: MoyaProvider<BandalArtTarget>
  init() { provider = MoyaProvider<BandalArtTarget>() }
}

extension BandalArtRepository {

    /// 반다라트 상세 조회 API
    /// - Parameters:
    ///   - key: 반다라트의 Unique Key.
    /// - Returns: `AnyPublisher<BandalArtDetailResponse, MoyaError>`
    func getBandalArtDetail(key: String) -> AnyPublisher<BandalArtDetailResponse, MoyaError> {
        return self.provider.requestPublisher(.getBandalArtDetail(bandalArtKey: key))
            .map(BandalArtDetailResponse.self)
    }
    
    /// 메인셀, 하위셀 모두 조회 API
    /// - Parameters:
    ///   - key: 반다라트의 Unique Key.
    /// - Returns: `AnyPublisher<BandalArtCellInfoResponse, MoyaError>`
    func getBandalArtCellList(key: String) -> AnyPublisher<BandalArtCellInfoResponse, MoyaError> {
        return self.provider.requestPublisher(.getMainCell(bandalArtKey: key))
            .map(BandalArtCellInfoResponse.self)
    }
}
