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
    // get
    case getBandalArtList // 반다라트 목록 조회
    case getBandalArtDetail(bandalArtKey: String) // 반다라트 상세 조회
    // case updateBandalArt(parameters: DictionaryType, BandalArtKey: String)
    // case deleteBandalArt(bandalArtKey: String)
    case getMainCell(bandalArtKey: String) // 반다라트 메인 셀 조회
    case getCell(bandalArtKey: String, cellKey: String) // 반다라트 하위 셀 조회
    case updateCell(parameters: DictionaryType, bandalArtKey: String, cellKey: String)
    // case deleteCell(key: String, cellKey: String)
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
    case .getBandalArtList:
      return "/v1/bandalarts"
    case .getBandalArtDetail(let bandalArtKey):
      return "/v1/bandalarts/\(bandalArtKey)"
    case .getMainCell(let bandalArtKey):
      return "/v1/bandalarts/\(bandalArtKey)/cells"
    case .getCell(let bandalArtKey, let cellKey):
      return "/v1/bandalarts/\(bandalArtKey)/cells/\(cellKey)"
    case .updateCell(_, bandalArtKey: let bandalArtKey, cellKey: let cellKey):
      return "/v1/bandalarts/\(bandalArtKey)/cells/\(cellKey)"
    }
  }
    
  var method: Moya.Method {
    switch self {
    case .getBandalArtList,
        .getBandalArtDetail,
        .getMainCell,
        .getCell:
      return .get
    case .updateCell:
      return .patch
    }
  }
    
  var sampleData: Data {
    return stubData(self)
  }
    
  var task: Task {
    switch self {
    case .getBandalArtList,
         .getBandalArtDetail,
         .getMainCell,
         .getCell:
      return .requestPlain
    case .updateCell(parameters: let parameters, _, _):
      return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
//    case :
//      return .requestPlain
//    case :
//      return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
//    case :
//      return .requestParameters(parameters: parameters, encoding: URLEncoding(arrayEncoding: .noBrackets))
    }
  }
  var validationType: ValidationType {
    return .customCodes([200])
  }

  var headers: [String: String]? {
//    guard let token = UserDefaults.standard.string(forKey: UserDefaultKey.guestToken) else {
//      return ["Content-Type": "application/json"]
//    }
//    let token = "3sF4I" //게스트 등록 API 나오기까지 임시.
    return [
      "Content-Type": "application/json",
//      "idtoken": token
    ]
  }
}
