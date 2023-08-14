//
//  APIEnvironment.swift
//  Network
//
//  Created by Youngmin Kim on 2023/08/02.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation

enum APIEnvironment {
    case dev
    case production
    
    var urlString: String {
        switch self {
        case .dev: return ""
        case .production: return Bundle.main.apiKey ?? ""
        }
    }
}


fileprivate extension Bundle {
    
    var apiKey: String? {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY"] as? String else {
            assertionFailure("⛔️ API KEY를 가져오는데 실패하였습니다.")
            return nil
        }
        return key
    }
    
}
