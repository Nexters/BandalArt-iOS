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

    // Task 케이스
    func postTaskUpdateData(
      key: String,
      cellKey: String,
      title: String,
      description: String?,
      dueDate: Date?,
      isCompleted: Bool = false
    ) -> AnyPublisher<Bool, BandalArtNetworkError> {
      let parameters: DictionaryType = [
        "title": title,
        "description": description ?? NSNull(),
        "dueDate": dueDate ?? NSNull(),
        "isCompleted": isCompleted
      ]

      return self.provider.requestPublisher(
        .updateCell(
          parameters: parameters,
          bandalArtKey: key,
          cellKey: cellKey
        )
      )
      .tryMap { response -> Bool in
        if response.response?.statusCode == 200 {
          return true
        } else {
          return false
        }
      }
      .mapError { error in
        guard let mError = error as? MoyaError else { return BandalArtNetworkError.unknown }
        return BandalArtNetworkError(rawValue: mError.response?.statusCode ?? -1) ?? .unknown
      }
      .eraseToAnyPublisher()
    }

    // SubGoal 케이스
    func postTaskUpdateData(
      key: String,
      cellKey: String,
      title: String,
      description: String?,
      dueDate: Date?
    ) -> AnyPublisher<Bool, BandalArtNetworkError> {
      let parameters: DictionaryType = [
        "title": title,
        "description": description ?? NSNull(),
        "dueDate": dueDate ?? NSNull()
      ]

      return self.provider.requestPublisher(
        .updateCell(
          parameters: parameters,
          bandalArtKey: key,
          cellKey: cellKey
        )
      )
      .tryMap { response -> Bool in
        if response.response?.statusCode == 200 {
          return true
        } else {
          return false
        }
      }
      .mapError { error in
        guard let mError = error as? MoyaError else { return BandalArtNetworkError.unknown }
        return BandalArtNetworkError(rawValue: mError.response?.statusCode ?? -1) ?? .unknown
      }
      .eraseToAnyPublisher()
    }

    // mainGoal 케이스
    func postTaskUpdateData(
      key: String,
      cellKey: String,
      profileEmoji: Character?,
      title: String,
      description: String?,
      dueDate: Date?,
      mainColor: String,
      subColor: String
    ) -> AnyPublisher<Bool, BandalArtNetworkError> {
      let parameters: DictionaryType = [
        "title": title,
        "description": description ?? NSNull(),
        "dueDate": dueDate ?? NSNull(),
        "mainColor": mainColor,
        "subColor": subColor,
        "profileEmoji": profileEmoji ?? NSNull()
      ]

      return self.provider.requestPublisher(
        .updateCell(
          parameters: parameters,
          bandalArtKey: key,
          cellKey: cellKey
        )
      )
      .tryMap { response -> Bool in
        if response.response?.statusCode == 200 {
          return true
        } else {
          return false
        }
      }
      .mapError { error in
        guard let mError = error as? MoyaError else { return BandalArtNetworkError.unknown }
        return BandalArtNetworkError(rawValue: mError.response?.statusCode ?? -1) ?? .unknown
      }
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
    
    func mapToVoid() -> AnyPublisher<Void, BandalArtNetworkError> {
        return self.tryMap { _ in
            return ()
        }.mapError { error in
            guard let mError = error as? MoyaError else { return BandalArtNetworkError.unknown }
            return BandalArtNetworkError(rawValue: mError.response?.statusCode ?? -1) ?? .unknown
        }
        .eraseToAnyPublisher()
    }
}
