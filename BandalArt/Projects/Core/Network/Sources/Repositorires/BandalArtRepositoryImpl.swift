//
//  BandalArtRepositoryImpl.swift
//  Network
//
//  Created by Sang hun Lee on 2023/07/27.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Interface
import Entity

import Combine
import CombineMoya
import Moya

public final class BandalArtRepositoryImpl: BandalArtRepository {
    
  private let provider: MoyaProvider<BandalArtTarget>
  public init() { provider = MoyaProvider<BandalArtTarget>() }
}

public extension BandalArtRepositoryImpl {

    // 반다라트 상세 조회 API
    func getBandalArtDetail(key: String) -> AnyPublisher<BandalArtInfo, BandalArtNetworkError> {
        return self.provider.requestPublisher(.getBandalArtDetail(bandalArtKey: key))
            .mapToDomain(BandalArtDetailResponseDTO.self)
            .map { $0.toDomain }
            .eraseToAnyPublisher()
    }
    
    // 메인셀, 하위셀 모두 조회 API
    func getBandalArtCellList(key: String) -> AnyPublisher<BandalArtCellInfo, BandalArtNetworkError> {
        return self.provider.requestPublisher(.getMainCell(bandalArtKey: key))
            .mapToDomain(BandalArtCellInfoResponseDTO.self)
            .map { $0.toDomain }
            .eraseToAnyPublisher()
    }
}

// MoyaError를 사용하지 않고 BandarArt API 서비스 자체의
// Domain Error를 사용하려고 만든 Extension.
fileprivate extension AnyPublisher<Response, MoyaError> {
    
    func mapToDomain<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil,
                           using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> AnyPublisher<D, BandalArtNetworkError> {
        decoder.dateDecodingStrategy = .iso8601
        
        return self.tryMap { response in
            return try response.map(type, atKeyPath: keyPath, using: decoder,
                                    failsOnEmptyData: failsOnEmptyData)
        }.mapError { error in
            guard let mError = error as? MoyaError else { return BandalArtNetworkError.unknown }
            return BandalArtNetworkError(rawValue: mError.response?.statusCode ?? -1) ?? .unknown
        }
        .eraseToAnyPublisher()
    }
}
