//
//  BandalArtRepositoryImpl.swift
//  Network
//
//  Created by Sang hun Lee on 2023/07/27.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Combine
import CombineMoya
import Moya

final class BandalArtRepositoryImpl: BandalArtRepositoryInterface {
  private let provider: MoyaProvider<BandalArtTarget>
  init() { provider = MoyaProvider<BandalArtTarget>() }
}

extension BandalArtRepositoryImpl {

    /// 반다라트 상세 조회 API
    /// - Parameters:
    ///   - key: 반다라트의 Unique Key.
    /// - Returns: `AnyPublisher<BandalArtDetailResponse, MoyaError>`
    func getBandalArtDetail(key: String) -> AnyPublisher<BandalArtDetailResponseDTO, MoyaError> {
        return self.provider.requestPublisher(.getBandalArtDetail(bandalArtKey: key))
            .map(BandalArtDetailResponseDTO.self)
    }
    
    /// 메인셀, 하위셀 모두 조회 API
    /// - Parameters:
    ///   - key: 반다라트의 Unique Key.
    /// - Returns: `AnyPublisher<BandalArtCellInfoResponse, MoyaError>`
    func getBandalArtCellList(key: String) -> AnyPublisher<BandalArtCellInfoResponseDTO, MoyaError> {
        return self.provider.requestPublisher(.getMainCell(bandalArtKey: key))
            .map(BandalArtCellInfoResponseDTO.self)
    }
}
