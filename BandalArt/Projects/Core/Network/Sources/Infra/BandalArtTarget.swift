//
//  BandalArtTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/19.
//

import Foundation
import Moya
import Util

typealias DictionaryType = [String: Any]

enum BandalArtTarget {
    // POST
    case postBandalArt // 반다라트 생성
    case postGuest // 게스트 생성
    // GET
    case getBandalArtList // 반다라트 목록 조회
    case getBandalArtDetail(bandalArtKey: String) // 반다라트 상세 조회
    case getGuest // 게스트 조회
    case getMainCell(bandalArtKey: String) // 반다라트 메인 셀 조회
    case getCell(bandalArtKey: String, cellKey: String) // 반다라트 하위 셀 조회
    // DELETE
    case deleteBandalArt(bandalArtKey: String) // 반다라트 삭제
    // case deleteCell(key: String, cellKey: String)
    // PATCH
    case patchCell(parameters: DictionaryType, bandalArtKey: String, cellKey: String)
    // case updateBandalArt(parameters: DictionaryType, BandalArtKey: String)
}

extension BandalArtTarget: TargetType {
    
  var baseURL: URL {
    guard let url = URL(string: APIConstant.environment.urlString) else {
      fatalError("fatal error - invalid api url")
    }
    return url
  }
    
  var path: String {
    switch self {
    case .postGuest, .getGuest:
        return "/v1/users/guests"
    case .postBandalArt, .getBandalArtList:
      return "/v1/bandalarts"
    case .getBandalArtDetail(let bandalArtKey),
            .deleteBandalArt(let bandalArtKey):
      return "/v1/bandalarts/\(bandalArtKey)"
    case .getMainCell(let bandalArtKey):
      return "/v1/bandalarts/\(bandalArtKey)/cells"
    case .getCell(let bandalArtKey, let cellKey):
      return "/v1/bandalarts/\(bandalArtKey)/cells/\(cellKey)"
    case .patchCell(_, let bandalArtKey, let cellKey):
      return "/v1/bandalarts/\(bandalArtKey)/cells/\(cellKey)"
    }
  }
    
  var method: Moya.Method {
    switch self {
    case .postBandalArt,
         .postGuest:
      return .post
    case .getBandalArtList,
        .getBandalArtDetail,
        .getMainCell,
        .getCell,
        .getGuest:
      return .get
    case .patchCell:
      return .patch
    case .deleteBandalArt:
      return .delete
    }
  }
    
  var sampleData: Data {
    return stubData(self)
  }
    
  var task: Task {
    switch self {
    case .postGuest,
         .postBandalArt,
         .getBandalArtList,
         .getGuest,
         .getBandalArtDetail,
         .getMainCell,
         .getCell,
         .deleteBandalArt:
      return .requestPlain
        
    case .patchCell(let parameters, _, _):
      return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
//    case :
//      return .requestPlain
//    case :
//      return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
//    case :
//      return .requestParameters(parameters: parameters, encoding: URLEncoding(arrayEncoding: .noBrackets))
    }
  }
  var validationType: ValidationType {
    return .customCodes([200, 201])
  }

  var headers: [String: String]? {
    return [
      "X-GUEST-KEY": UserDefaultsManager.guestToken ?? ""
    ]
  }
}
