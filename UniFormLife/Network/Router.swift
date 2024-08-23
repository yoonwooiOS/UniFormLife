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
    case uploadPostImage
    case uploadPost
    case fetchPost(productID: String)
    case fetchspecificPost
    case editPost(data: EditPostQuery)
    case deletePost(postID: String)
    case fetchUserPost(userID: String)
    case createComment(postID: String)
    case editComment(postID: String, commentID: String)
    case deleteComment(postID: String, commentID: String)
    case likePost(postID: String)
    
    
    
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
        case .uploadPostImage:
            return .post
        case .uploadPost:
            return .post
        case .fetchPost:
            return .get
        case .fetchspecificPost:
            return .get
        case .editPost(data: let data):
            return .put
        case .deletePost(postID: let postID):
            return .delete
        case .fetchUserPost(userID: let userID):
            return .get
        case .createComment(postID: let postID):
            return .post
        case .editComment(postID: let PosdtID):
            return .put
        case .deleteComment(postID: let postID, commentID: let commentID):
            return .delete
        case .likePost(postID: let postID):
            return .post
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchPost(let productID):
            return [URLQueryItem(name: "product_id", value: productID)]
        default:
            return nil
        }
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
        case .editPost(let data):
            let encoding = JSONEncoder()
            return try? encoding.encode(data)
        case .createComment(let postID):
            let encoding = JSONEncoder()
            return try? encoding.encode(postID)
        default:
            return nil
        }
    }
}
extension Router {
    var baseURL: String {
        return APIKey.baseURL + "v1/"
    }
    var path: String {
        switch self {
        case .login:
            return "users/login"
        case .fetchProfile, .editProfile:
            return  "users/me/profile"
        case .refresh:
            return "auth/refresh"
        case .validateEmail:
            return "validation/email"
        case .importPost:
            return "posts"
        case .withdrawAccount:
            return "users/withdraw"
        case .uploadPostImage:
            return "posts/files"
        case .uploadPost:
            return "posts"
        case .fetchPost:
            return "posts"
        case .fetchspecificPost:
            return "posts/:id"
        case .editPost:
            return "posts/:id"
        case .deletePost(postID: let postID):
            return "posts/\(postID)"
        case .fetchUserPost(userID: let userID):
            return "posts/:\(userID)"
        case .createComment(postID: let postID):
            return "posts/\(postID)/comments"
        case .editComment(postID: let postID, commentID: let commentID):
            return "posts/\(postID)/comments/\(commentID)"
        case .deleteComment(postID: let postID, commentID: let commentID):
            return "posts/\(postID)/comments/\(commentID)"
        case .likePost(postID: let postID):
            return "posts/\(postID)/like"
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
        case .uploadPostImage:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .uploadPost:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .fetchPost:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.sesacKey.rawValue : APIKey.key
            ]
        
        case .fetchspecificPost:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .editPost:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .deletePost:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .fetchUserPost(userID: let userID):
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .createComment(postID: let postID):
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .editComment(postID: let postID, commentID: let commentID):
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .deleteComment(postID: let postID, commentID: let commentID):
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .likePost(postID: let postID):
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.sesacKey.rawValue : APIKey.key
            ]
        }
    }
}
