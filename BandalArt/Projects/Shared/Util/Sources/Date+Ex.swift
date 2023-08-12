//
//  Date+Ex.swift
//  Util
//
//  Created by meng on 2023/08/13.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation

public extension Date {

    var toString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yy년 MM월 d일"
        return formatter.string(from: self)
    }
}
