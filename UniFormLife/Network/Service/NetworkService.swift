//
//  NetworkService.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/31/24.
//

import Alamofire
import Foundation
import RxSwift
import UIKit

final class NetworkService {
    static let shared = NetworkService()
    static let session = Session(interceptor: NetworkInterceptor())
    private init() { }
    //MARK: 로그인, 회원가입 쪽 네트워크 리팩토링
    func makeRequest<T: Decodable>(route: URLRequestConvertible, responseType: T.Type, completion: @escaping (T) -> Void) -> Single<T> {
        return Single<T>.create { single in
            do {
                let urlRequest = try route.asURLRequest()
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: responseType) { response in
                        switch response.result {
                        case .success(let value):
                            completion(value)
                            single(.success(value))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    //MARK: 포스트 조회
    func fetchPost(query: FetchPostQuery) -> Single<Result<FetchPost, Error>> {
        print("fetchPost요청: \(query)")
        return Single<Result<FetchPost, Error>>.create { single in
            do {
                let urlRequest = try Router.fetchPost(query: query).asURLRequest()
                NetworkService.session.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: FetchPost.self) { response in
                        switch response.result {
                        case .success(let success):
                            dump("fetchPost 성공: \(success)")
                            single(.success(.success(success)))
                        case .failure(let error):
                            print("fetchPost 실패: \(error)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                print("Error creating request: \(error)")
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    //MARK: 특정 포스트 조회
    func fetchSpecificPost(postID: String) -> Single<Result<PostData, Error>> {
        return Single<Result<PostData, Error>>.create { single in
            do {
                let urlRequest = try Router.fetchspecificPost(postID: postID).asURLRequest()
                NetworkService.session.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: PostData.self) { response in
                        switch response.result {
                        case .success(let success):
                            print("fetchSpecificPost 성공: \(success)")
                            single(.success(.success(success)))
                        case .failure(let error):
                            print("fetchSpecificPost 실패: \(error)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                print("Error creating request: \(error)")
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    //MARK: 특정 유저 포스트 조회
    func fetchUserPost(userId: String) -> Single<Result<FetchPost, Error>> {
        return Single<Result<FetchPost, Error>>.create { single in
            do {
                let urlRequest = try Router.fetchUserPost(userID: userId).asURLRequest()
                NetworkService.session.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: FetchPost.self) { response in
                        switch response.result {
                        case .success(let success):
                            print("fetchUserPost 성공: \(success)")
                            single(.success(.success(success)))
                        case .failure(let error):
                            print("fetchUserPost 실패: \(error)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                print("Error creating request: \(error)")
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    //MARK: 이미지 업로드
    func uploadImagefiles(images: [UIImage]) -> Single<Result<[String], Error>> {
        return Single.create { single -> Disposable in
            do {
                let router = Router.uploadPostImage
                let request = try router.asURLRequest()
                
                NetworkService.session.upload(multipartFormData: { multipartFormData in
                    for (index, image) in images.enumerated() {
                        if let imageData = image.pngData() {
                            multipartFormData.append(imageData, withName: "files", fileName: "image\(index).png", mimeType: "image/png")
                            print("이미지 \(index) 추가됨")
                        }
                    }
                }, with: request)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Files.self) { response in
                    switch response.result {
                    case .success(let value):
                        print("uploadImagefiles 성공: \(value)")
                        single(.success(.success(value.files)))
                    case .failure(let error):
                        print("uploadImagefiles 실패: \(error)")
                        single(.success(.failure(error)))
                    }
                }
            } catch {
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    //MARK: 포스트 업로드
    func uploadPost(_ postRequestModel: UploadPostQuery) -> Single<Result<PostData, Error>> {
        return Single<Result<PostData, Error>>.create { single in
            do {
                let urlRequest = try Router.uploadPost(postData: postRequestModel).asURLRequest()
                print("URL Request: \(urlRequest)")
                
                NetworkService.session.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: PostData.self) { response in
                        switch response.result {
                        case .success(let success):
                            print("uploadPost 성공: \(success)")
                            single(.success(.success(success)))
                        case .failure(let error):
                            print("uploadPost 실패: \(error)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    //MARK: 포스트 수정
    func editPost(postID: String, postRequestModel: EditPostQuery) -> Single<Result<PostData, Error>> {
        return Single<Result<PostData, Error>>.create { single in
            do {
                let title = postRequestModel.title
                let content = postRequestModel.content
                let price = postRequestModel.price ?? 0
                let size = postRequestModel.size ?? ""
                let condition = postRequestModel.condition ?? ""
                let season = postRequestModel.season ?? ""
                let league = postRequestModel.league ?? ""
                let imageUrls = postRequestModel.imageUrls ?? []
                let urlRequest = try Router.editPost(postID: postID, query: EditPostQuery(title: title, content: content, price: price, size: size, condition: condition, season: season, league: league, imageUrls: imageUrls)).asURLRequest()
                print("URL Request: \(urlRequest)")
                NetworkService.session.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: PostData.self) { response in
                        switch response.result {
                        case .success(let success):
                            print("editPostRequest 성공: \(success)")
                            single(.success(.success(success)))
                        case .failure(let error):
                            print("editPostRequest 실패: \(error)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    //MARK: 포스트 삭제
    func deletePost(postId: String) -> Single<Result<Void, Error>> {
        return Single<Result<Void, Error>>.create { single in
            let urlRequest: URLRequest
            do {
                urlRequest = try Router.deletePost(postID: postId).asURLRequest()
            } catch {
                single(.success(.failure(error)))
                return Disposables.create()
            }
            NetworkService.session.request(urlRequest)
                .response { response in
                    print("deletePost statusCode: \(response.response?.statusCode ?? 0)")
                    switch response.result {
                    case .success:
                        if let statusCode = response.response?.statusCode, statusCode == 200 {
                            print("deletePost 성공")
                            single(.success(.success(())))
                        } else {
                            print("deletePost error: \(String(describing: response.response?.statusCode))")
                            single(.failure(response.result as! Error))
                        }
                    case .failure(let error):
                        print("deletePost 실패: \(error)")
                        single(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }
    }
    
    func createComment(postID: String, content: CommnetQuery) -> Single<Result<CreateComment, Error>> {
        return Single<Result<CreateComment, Error>>.create { single in
            do {
                let urlRequest = try Router.createComment(postID: postID, query: content).asURLRequest()
                print("URL Request: \(urlRequest)")
                
                NetworkService.session.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: CreateComment.self) { response in
                        switch response.result {
                        case .success(let success):
                            print("createComment 성공: \(success)")
                            single(.success(.success(success)))
                        case .failure(let error):
                            print("createComment 실패: \(error)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    func editCommnet(postID: String, commentID: String, content: CommnetQuery) -> Single<Result<CreateComment, Error>> {
        return Single<Result<CreateComment, Error>>.create { single in
            do {
                let urlRequest = try Router.editComment(postID: postID, commentID: commentID, query: content).asURLRequest()
                print("URL Request: \(urlRequest)")
                
                NetworkService.session.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: CreateComment.self) { response in
                        switch response.result {
                        case .success(let success):
                            print("editCommnet 성공: \(success)")
                            single(.success(.success(success)))
                        case .failure(let error):
                            print("editCommnet 실패: \(error)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    func deleteComment(postId: String, comment: CommnetQuery, commnetID: String) -> Single<Result<Void, Error>> {
        return Single<Result<Void, Error>>.create { single in
            let urlRequest: URLRequest
            do {
                urlRequest = try Router.deleteComment(postID: postId, query: comment, commentID: commnetID).asURLRequest()
            } catch {
                single(.success(.failure(error)))
                return Disposables.create()
            }
            print("URL Request: \(urlRequest)")
            NetworkService.session.request(urlRequest)
                .response { response in
                    print("deleteComment statusCode: \(response.response?.statusCode ?? 0)")
                    switch response.result {
                    case .success:
                        if let statusCode = response.response?.statusCode, statusCode == 200 {
                            print("deleteComment 성공")
                            single(.success(.success(())))
                        } else {
                            print("deleteComment error: \(String(describing: response.response?.statusCode))")
                            single(.failure(response.result as! Error))
                        }
                    case .failure(let error):
                        print("deleteComment 실패: \(error)")
                        single(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }
    }
    
    func likePost(postID: String ,query: LikeQuery) -> Single<Result<LikePost, Error>> {
        return Single<Result<LikePost, Error>>.create { single in
            do {
                let urlRequest = try Router.likePost(postID: postID, query: query).asURLRequest()
                print("URL Request: \(urlRequest)")
                
                NetworkService.session.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: LikePost.self) { response in
                        switch response.result {
                        case .success(let success):
                            print("likePost 성공: \(success)")
                            single(.success(.success(success)))
                        case .failure(let error):
                            print("likePost 실패: \(error)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    func fetchLikedPost() -> Single<Result<FetchPost, Error>> {
        return Single<Result<FetchPost, Error>>.create { single in
            do {
                let urlRequest = try Router.fetchLikedPost.asURLRequest()
                NetworkService.session.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: FetchPost.self) { response in
                        switch response.result {
                        case .success(let success):
                            print("fetchLikedPost 성공: \(success)")
                            single(.success(.success(success)))
                        case .failure(let error):
                            print("fetchLikedPost 실패: \(error)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                print("fetchLikedPost: \(error)")
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    func fetchMyProfile() -> Single<Result<FetchMyProfile, Error>> {
        return Single<Result<FetchMyProfile, Error>>.create { single in
            do {
                let urlRequest = try Router.fetchMyProfile.asURLRequest()
                print("URL Request: \(urlRequest)")
                
                NetworkService.session.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: FetchMyProfile.self) { response in
                        switch response.result {
                        case .success(let success):
                            print("fetchMyProfile 성공: \(success)")
                            single(.success(.success(success)))
                        case .failure(let error):
                            print("fetchMyProfile 실패: \(error)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    func editMyProfile(editProfile: EditMyprofileQuery) -> Single<Result<FetchMyProfile, Error>> {
        return Single<Result<FetchMyProfile, Error>>.create { single in
            do {
                let urlRequest = try Router.editMyProfile(query: editProfile).asURLRequest()
                print("URL Request: \(urlRequest)")
                NetworkService.session.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: FetchMyProfile.self) { response in
                        switch response.result {
                        case .success(let success):
                            print("fetchMyProfile 성공: \(success)")
                            single(.success(.success(success)))
                        case .failure(let error):
                            print("fetchMyProfile 실패: \(error)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    func refreshToken() -> Single<Refresh> {
        return self.makeRequest(route: Router.refresh, responseType: Refresh.self) { refreshToken in
            UserDefaultsManeger.shared.token = refreshToken.accessToken
        }
    }
}


