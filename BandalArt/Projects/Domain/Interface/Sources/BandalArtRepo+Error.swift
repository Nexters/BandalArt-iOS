//
//  BandalArtRepo+Error.swift
//  Interface
//
//  Created by Youngmin Kim on 2023/08/06.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Entity

import Combine

// MARK: - BandalArt API Error.
public enum BandalArtNetworkError: Int, Error {

    case inValidTokenError = 401
    case inValidURLORKey = 404
    case internalServerError = 500
    case internalClientError = 501
    case unknown

    var description: String { self.errorDescription }
}

extension BandalArtNetworkError {

    var errorDescription: String {
        switch self {
        case .inValidTokenError: return "401:INVALID_TOKEN_ERROR"
        case .inValidURLORKey: return "404:INVALID_URL_OR_KEY_ERROR"
        case .internalServerError: return "500:INTERNAL_SERVER_ERROR"
        case .internalClientError: return "501:INTERNAL_CLIENT_ERROR"
        default: return "UN_KNOWN_ERROR"
        }
    }
}

// MARK: - BandalArt API 레파지토리.
public protocol BandalArtRepository {
    
    /// 반다라트 상세 조회 API
    /// - Parameters:
    ///   - key: 반다라트의 Unique Key.
    /// - Returns: `AnyPublisher<BandalArtInfo, BandalArtNetworkError>`
    func getBandalArtDetail(key: String) -> AnyPublisher<BandalArtInfo, BandalArtNetworkError>
    
    /// 메인셀, 하위셀 모두 조회 API
    /// - Parameters:
    ///   - key: 반다라트의 Unique Key.
    /// - Returns: `AnyPublisher<BandalArtCellInfo, BandalArtNetworkError>`
    func getBandalArtCellList(key: String) -> AnyPublisher<BandalArtCellInfo, BandalArtNetworkError>
}
