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
    case importPost
    case validateEmail(email: String)
    case withdrawAccount
    case upLoadPostImage
    
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
        case .importPost:
            return .get
        case .validateEmail:
            return .post
        case .withdrawAccount:
            return .get
        case .upLoadPostImage:
            return .post
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
            return try? encoding.encode(query)
        case.validateEmail(let email):
            let encoding = JSONEncoder()
            let query = ["email": email]
            return try? encoding.encode(query)
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
        case .validateEmail:
            return "/validation/email"
        case .importPost:
            return "/posts"
        case .withdrawAccount:
            return "/users/withdraw"
        case .upLoadPostImage:
            return "/posts/files"
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
        case .importPost:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .validateEmail:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .withdrawAccount:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .upLoadPostImage:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.sesacKey.rawValue : APIKey.key
            ]
        }
    }
}
