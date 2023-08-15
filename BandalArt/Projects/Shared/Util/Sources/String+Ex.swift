//
//  String+Ex.swift
//  Util
//
//  Created by Sang hun Lee on 2023/08/12.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation

extension String {
  public func removingBlankLines() -> String {
    let pattern = "\\s*\\n|\\s+"
    let regex = try! NSRegularExpression(pattern: pattern)
    let range = NSRange(self.startIndex..., in: self)
    return regex.stringByReplacingMatches(in: self, range: range, withTemplate: "\n")
  }
  
  public func consistsOfWhitespace() -> Bool {
    let pattern = "^[\\s\\n]*$" // 시작과 끝에 0개 이상의 공백 또는 줄바꿈 문자가 있는지 검출
    return range(of: pattern, options: .regularExpression) != nil
  }
}
