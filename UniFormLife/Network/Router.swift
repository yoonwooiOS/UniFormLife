//
//  Router.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import Foundation
import Alamofire

enum Router: TargetType {
    case login(query: LoginQuery)
    case fetchProfile
    case editProfile
    case refresh
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        case .fetchProfile:
            return .get
        case .editProfile:
            return .put
        case .refresh:
            return .get
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .login(let query):
            let encoding = JSONEncoder()
            print(query, "😀")
//            return try? encoding.encode(query)
            let a = try? encoding.encode(query)
            print(a,"😀")
            return a
        default:
            return nil
        }
       
    }
}
extension Router {
    var baseURL: String {
        return APIKey.baseURL + "v1"
    }
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .fetchProfile, .editProfile:
           return  "/users/me/profile"
        case .refresh:
            return "/auth/refresh"
        }
    }
    var header: [String: String] {
        switch self {
        case .login:
            return [
            Header.contentType.rawValue: Header.json.rawValue,
            Header.sesacKey.rawValue : APIKey.key
            ]
        case .fetchProfile:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .editProfile:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: "multipart/form-data",
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .refresh:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.refresh.rawValue: UserDefaultsManeger.shared.refreshToken,
                Header.sesacKey.rawValue: APIKey.key
                ]
        }
    }
}
