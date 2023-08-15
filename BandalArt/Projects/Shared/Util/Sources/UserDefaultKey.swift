//
//  UserDefaultKey.swift
//  Util
//
//  Created by Sang hun Lee on 2023/07/28.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation

// 유저 디폴트에 대한 케이스 추가시 여기에 추가하고 이용
public struct UserDefaultsManager {
    
    @UserDefaultWrapper(key: "guestToken", defaultValue: nil)
    public static var guestToken: String?
    
    @UserDefaultWrapper(key: "lastUserBandalArtKey", defaultValue: nil)
    public static var lastUserBandalArtKey: String?
}

@propertyWrapper
public struct UserDefaultWrapper<T> {
    
    private let key: String
    private let defaultValue: T

    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get { return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}
