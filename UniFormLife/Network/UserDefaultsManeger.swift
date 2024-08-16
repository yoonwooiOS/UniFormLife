//
//  UserDefaultsManeger.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import Foundation

private enum UserDefaultsKey: String {
    case access
    case refresh
}

final class UserDefaultsManeger {
    
    static let shared = UserDefaultsManeger()
    
    private init() { }
    
    var token: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.access.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.access.rawValue)
        }
    }
    var refreshToken: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.refresh.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.refresh.rawValue)
        }
    }
}
