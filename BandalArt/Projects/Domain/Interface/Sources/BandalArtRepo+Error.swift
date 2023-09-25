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

    case inValidBody = 400
    case inValidTokenError = 401
    case inValidURLORKey = 404
    case internalServerError = 500
    case internalClientError = 2
    case decodingError = 200
    case unknown = -1

    var description: String { self.errorDescription }
}

public extension BandalArtNetworkError {

    var errorDescription: String {
        switch self {
        case .inValidBody: return "400:CANBE_INVALID_BODY_ERROR"
        case .inValidTokenError: return "401:INVALID_TOKEN_ERROR"
        case .inValidURLORKey: return "404:INVALID_URL_OR_KEY_ERROR"
        case .internalServerError: return "500:INTERNAL_SERVER_ERROR"
        case .internalClientError: return "INTERNAL_CLIENT_ERROR"
        case .decodingError: return "SUCCESS_BUT_DECODING_ERROR"
        default: return "UN_KNOWN_ERROR"
        }
    }
}

// MARK: - BandalArt API 레파지토리.
public protocol BandalArtRepository {
    
    /**
     게스트 생성 API
    - Returns: 성공시 게스트 Key 리턴. 실패시 반다라트 에러 리턴.
     */
    func postGuest() -> AnyPublisher<String, BandalArtNetworkError>
    
    /**
     반다라트 생성 API
    - Returns: 성공시 반다라트 Key 리턴. 실패시 반다라트 에러 리턴.
     */
    func postBandalArt() -> AnyPublisher<String, BandalArtNetworkError>
    
    /**
    반다라트 상세 조회 API
    - Parameters:
    - key: 반다라트의 Unique Key.
    - Returns: `AnyPublisher<BandalArtInfo, BandalArtNetworkError>`
     */
    func getBandalArtDetail(key: String) -> AnyPublisher<BandalArtInfo, BandalArtNetworkError>
    
    /**
    메인셀, 하위셀 모두 조회 API
    - Parameters:
    - key: 반다라트의 Unique Key.
    - Returns: `AnyPublisher<BandalArtCellInfo, BandalArtNetworkError>`
     */
    func getBandalArtCellList(
      key: String
    ) -> AnyPublisher<BandalArtCellInfo, BandalArtNetworkError>
    
    /**
     반다라트 삭제 API
    - Returns: 성공시 반다라트 Void 리턴. 실패시 반다라트 에러 리턴.
     */
    func deleteBandalArt(key: String) -> AnyPublisher<Void, BandalArtNetworkError>
    
    /**
     반다라트 웹 공유 URL 생성 API
    - Parameters:
    - key: 반다라트의 Unique Key.
    - Returns: 성공시 웹 URL String 리턴
     */
    func postWebURL(key: String) -> AnyPublisher<String, BandalArtNetworkError>
    
  
  /// 반다라트 cell 수정 API
  /// - Parameters:
  ///   - key: 반다라트의 Unique Key.
  ///   - cellKey: cell의 식별 Key
  ///   - title: 제목
  ///   - description: 메모
  ///   - dueDate: 달성일
  ///   - isCompleted: only Task
  ///   - mainColor: only mainGoal
  ///   - subColor: only mainGoal
  ///   - profileEmoji:onyl mainGoal
  /// - Returns: `null - statusCode`
    
  /// Task에서 호출하는 경우
    func postTaskUpdateData(
      key: String,
      cellKey: String,
      title: String?,
      description: String?,
      dueDate: Date?,
      isCompleted: Bool?
    ) -> AnyPublisher<Void, BandalArtNetworkError>
  
    // MainGoal에서 호출하는 경우
    func postTaskUpdateData(
      key: String,
      cellKey: String,
      profileEmoji: Character?,
      title: String?,
      description: String?,
      dueDate: Date?,
      mainColor: String?,
      subColor: String
    ) -> AnyPublisher<Void, BandalArtNetworkError>
  
  /// 반다라트 cell 삭제 API
  /// - Parameters:
  ///   - key: 반다라트의 Unique Key.
  ///   - cellKey: cell의 식별 Key
  /// - Returns: `null - statusCode`
  
  func deleteTaskData(key: String, cellKey: String) -> AnyPublisher<Void, BandalArtNetworkError>
}
