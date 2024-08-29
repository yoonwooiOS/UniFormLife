//
//  NetworkManager.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import UIKit
import Alamofire
import RxSwift

final class NetworkManager {
    static let shared = NetworkManager()
    private init () { }
        func callRequest<T: Decodable>(router: Router, type: T.Type) -> Single<Result<T, Error>> {
            return Single.create { observer -> Disposable in
                do {
                    
                    let request = try router.asURLRequest()
                    if let httpBody = request.httpBody {
                                   let bodyString = String(data: httpBody, encoding: .utf8) ?? "바디 데이터 없음"
                                   print("Request Body: \(bodyString)")
                               } else {
                                   print("Request Body: 바디 데이터 없음")
                               }
                    AF.request(request).responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let success):
                           print(success,"callrequest")
                            observer(.success(.success(success)))
                        case .failure(let failure):
                            print("fail", failure)
                            observer(.success(.failure(failure)))
                            if response.response?.statusCode == 419 {
                                self.refreshToken()
                            }
                        }
                    }
                } catch {
                    print(error)
                }
                return Disposables.create()
            }
        }
    func callRequestNoData(router: Router) -> DataRequest {
           do {
               let request = try router.asURLRequest()
               return AF.request(request)
                   .validate(statusCode: 200..<300)  // 성공 상태 코드 범위 지정
           } catch {
               fatalError("Request could not be created: \(error)")
           }
       }
    func uploadImagefiles(images: [UIImage]) -> Single<Result<[String], Error>> {
        return Single.create { observer -> Disposable in
            do {
                let router = Router.uploadPostImage
                let request = try router.asURLRequest()
                
                AF.upload(multipartFormData: { multipartFormData in
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
                        print("서버 응답 성공: \(value)")
                        observer(.success(.success(value.files)))
                    case .failure(let error):
                        print("서버 응답 실패: \(error)")
                        observer(.success(.failure(error)))
                        if response.response?.statusCode == 419 {
                            self.refreshToken()
                        }
                    }
                }
            } catch {
                print("업로드 요청 실패: \(error)")
                observer(.success(.failure(error)))
            }
            return Disposables.create()
        }
    }
    func fetchPost(productID: String) -> Single<Result<FetchPost, Error>> {
        return Single.create { observer -> Disposable in
            do {
                let query = productID
                let request = try Router.fetchPost(productID: query).asURLRequest()
                
                AF.request(request).responseDecodable(of: FetchPost.self) { response in
                    if response.response?.statusCode == 419 {
                        self.refreshToken()
                    } else {
                        switch response.result {
                        case .success(let success):
                            dump(success)
                            observer(.success(.success(success)))
                        case .failure(let failure):
                            print(failure)
                            observer(.success(.failure(failure)))
                        }
                    }
                }
            } catch {
                print(error, "fetchProfile, URLRequestConvertible 에서 asURLRequest로 요청 만드는 것 실패!")
                observer(.success(.failure(error)))
            }
            
            return Disposables.create()
        }
        .debug("fetchPost")
    }
    
    func loginUser(email: String, password: String, loginCompletionHandler: @escaping (Result<Login, Error>) -> Void) -> Void {
        do {
            let query = LoginQuery(email: email, password: password)
            let request = try Router.login(query: query).asURLRequest()
            AF.request(request).responseDecodable(of: Login.self) { response in
                switch response.result{
                case .success(let success):
                    //                        print(success)
                    UserDefaultsManeger.shared.token = success.access
                    UserDefaultsManeger.shared.refreshToken = success.refresh
                    loginCompletionHandler(.success(success))
                    
                case .failure(let failure):
                    print("fail", failure)
                    if response.response?.statusCode == 419 {
                        //                             토큰 갱신
                        self.refreshToken()
                    }
                    loginCompletionHandler(.failure(failure))
                }
                
            }
        } catch {
            print(error)
        }
    }
    func fetchProfile() {
        do {
            let request = try Router.fetchProfile.asURLRequest()
            AF.request(request).responseDecodable(of: Profile.self) { response in
                if response.response?.statusCode == 419 {
                    self.refreshToken()
                } else {
                    switch response.result {
                    case .success(let success):
                        print(success)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        } catch {
            print(error, "fetchProfile, URLRequestConvertible 에서 asURLRequest로 요청 만드는 것 실패!")
        }
    }
    func refreshToken() {
        do {
            let request = try Router.refresh.asURLRequest()
            AF.request(request).responseDecodable(of: Refresh.self) { response in
                if response.response?.statusCode == 418 {
                    //rootViewController를 LoginViewController 전환 -> 로그인 해서 새로운 토큰 발급
                    //UserDefaults 제거
                    //MARK: 함수화
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    let navigationController = UINavigationController(rootViewController: SignInViewController())
                    sceneDelegate?.window?.rootViewController = navigationController
                    sceneDelegate?.window?.makeKeyAndVisible()
                    
                }
                switch response.result {
                case .success(let success):
                    print(success)
                    UserDefaultsManeger.shared.token = success.accessToken
                    self.fetchProfile()
                case .failure(let failure):
                    print(failure)
                }
            }
        } catch {
            print(error, "refreshToken, URLRequestConvertible 에서 asURLRequest로 요청 만드는 것 실패!")
        }
    }
}
