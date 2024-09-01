//
//  Router.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import Foundation
import Alamofire

enum Router: TargetType {
    case login(query: LoginQuery) // 로그인
    case refresh // refresh token
    case validateEmail(email: String) // email 중복 검사
    case withdrawAccount // 회원 탈퇴
    case uploadPostImage // 포스트 이미지 업로드
    case uploadPost(postData: UploadPostQuery) // 포스트 업로드
    case fetchPost(query: FetchPostQuery) // 포스트 조회
    case fetchspecificPost(postID: String) // 특정 포스트 조회
    case editPost(postID: String, query: EditPostQuery) // 포스트 수정
    case deletePost(postID: String) // 포스트 삭제
    case fetchUserPost(userID: String) // 특정 유저 포스트 조회
    case createComment(postID: String, query: CommnetQuery) // 댓글 달기
    case editComment(postID: String, commentID: String, query: CommnetQuery) // 댓글 수정
    case deleteComment(postID: String, query: CommnetQuery, commentID: String) // 댓글 삭제
    case likePost(postID: String, query: LikeQuery) // 포스트 좋아요
    case fetchLikedPost //내가 좋아요한 포스트
    case fetchMyProfile // 내 프로필 조회
    case editMyProfile(query: EditMyprofileQuery) // 내 프로필 수정
    case paymentValidation(validateData: PaymentValidateQuery) // 결제
    
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        case .refresh:
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
        case .editPost:
            return .put
        case .deletePost:
            return .delete
        case .fetchUserPost:
            return .get
        case .createComment:
            return .post
        case .editComment:
            return .put
        case .deleteComment:
            return .delete
        case .likePost:
            return .post
        case .paymentValidation:
            return .post
        case .fetchLikedPost:
            return .get
        case .fetchMyProfile:
            return .get
        case .editMyProfile(query: let query):
            return .put
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchPost(let query):
            var items = [
                URLQueryItem(name: "product_id", value: query.productID),
                URLQueryItem(name: "limit", value: query.limit)
            ]
            if let cursor = query.cursor, cursor != "0" {
                items.append(URLQueryItem(name: "next", value: cursor))
            }
            return items
            
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
        case .editPost(_, let postData):
            let encoding = JSONEncoder()
            return try? encoding.encode(postData)
        case .createComment(_ , let comment):
            let encoding = JSONEncoder()
            return try? encoding.encode(comment)
        case .editComment(_, _, let comment):
            let encoding = JSONEncoder()
            return try? encoding.encode(comment)
        case .likePost(_, let query):
            let encoding = JSONEncoder()
            return try? encoding.encode(query)
            
        case .uploadPost(let postData):
            let encoding = JSONEncoder()
            return try? encoding.encode(postData)
        case .paymentValidation(let validData):
            let encoding = JSONEncoder()
            return try? encoding.encode(validData)
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
        case .refresh:
            return "auth/refresh"
        case .validateEmail:
            return "validation/email"
        case .withdrawAccount:
            return "users/withdraw"
        case .uploadPostImage:
            return "posts/files"
        case .uploadPost:
            return "posts"
        case .fetchPost:
            return "posts"
        case .fetchspecificPost(let postID):
            return "posts/\(postID)"
        case .editPost(let postID, _):
            return "posts/\(postID)"
        case .deletePost(let postID):
            return "posts/\(postID)"
        case .fetchUserPost(userID: let userID):
            return "posts/users/\(userID)"
        case .createComment(let postID,_):
            return "posts/\(postID)/comments"
        case .editComment( let postID, let commentID, _):
            return "posts/\(postID)/comments/\(commentID)"
        case .deleteComment(let postID,_,let commentID):
            return "posts/\(postID)/comments/\(commentID)"
        case .likePost(let postID, _):
            return "posts/\(postID)/like"
        case .paymentValidation(_):
            return "payments/validation"
        case .fetchLikedPost:
            return "posts/likes/me"
        case .fetchMyProfile:
            return "users/me/profile"
        case .editMyProfile(query: let query):
            return "users/me/profile"
        }
    }
    var header: [String: String] {
        switch self {
        case .login:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .refresh:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.refresh.rawValue: UserDefaultsManeger.shared.refreshToken,
                Header.sesacKey.rawValue: APIKey.key
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
        case .fetchUserPost:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .createComment:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .editComment:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .deleteComment:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .likePost:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .paymentValidation:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .fetchLikedPost:
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .fetchMyProfile:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue : APIKey.key
            ]
        case .editMyProfile(query: let query):
            return [
                Header.authorization.rawValue: UserDefaultsManeger.shared.token,
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.sesacKey.rawValue : APIKey.key
            ]
        }
    }
}
