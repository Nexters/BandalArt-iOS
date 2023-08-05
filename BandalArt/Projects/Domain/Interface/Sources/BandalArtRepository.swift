//
//  BandalArtRepository.swift
//  Interface
//
//  Created by Youngmin Kim on 2023/08/06.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import Combine
import Entity

enum BandalArtNetworkError: Int, Error {

    case duplicatedError = 201
    case inValidInputBodyError = 202
    case inValidIDTokenError = 401
    case inValidURL = 404
    case unregisterUser = 406
    case internalServerError = 500
    case internalClientError = 501
    case unknown

    var description: String { self.errorDescription }
}

extension BandalArtNetworkError {

    var errorDescription: String {
        switch self {
        case .duplicatedError: return "201:DUPLICATE_ERROR"
        case .inValidInputBodyError: return "202:INVALID_INPUT_BODY_ERROR"
        case .inValidIDTokenError: return "401:INVALID_FCM_TOKEN_ERROR"
        case .inValidURL: return "404:INVALID_URL_ERROR"
        case .unregisterUser: return "406:UNREGISTER_USER_ERROR"
        case .internalServerError: return "500:INTERNAL_SERVER_ERROR"
        case .internalClientError: return "501:INTERNAL_CLIENT_ERROR"
        default: return "UN_KNOWN_ERROR"
        }
    }
}

protocol BandalArtRepository {
    
    func getBandalArtDetail(key: String) -> AnyPublisher<BandalArtInfo, BandalArtError>
    func getBandalArtCellList(key: String) -> AnyPublisher<BandalArtCell, BandalArtError>
}
