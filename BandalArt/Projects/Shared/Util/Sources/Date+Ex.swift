//
//  Date+Ex.swift
//  Util
//
//  Created by Sang hun Lee on 2023/08/12.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation

public extension Date {
  var toISO8601String: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(abbreviation: "KST")
    formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
    return formatter.string(from: self)
  }
  
  var toString: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(abbreviation: "KST")
    formatter.dateFormat = "yyyy년 MM월 d일"
    return formatter.string(from: self)
  }
}
