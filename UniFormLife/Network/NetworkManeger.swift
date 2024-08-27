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
//    func callRequest<T: Decodable>(router: Router, type: T.Type) -> Single<Result<T, Error>> {
//        return Single.create { observer -> Disposable in
//            do {
//                let request = try router.asURLRequest()
//                AF.request(request).responseJSON { response in
//                    // 상태 코드 확인
//                    if let statusCode = response.response?.statusCode {
//                        print("HTTP Status Code: \(statusCode)")
//                    }
//                    
//                    switch response.result {
//                    case .success(let value):
//                        // 상태 코드에 따른 분기 처리
//                        if let statusCode = response.response?.statusCode {
//                            switch statusCode {
//                            case 200:
//                                // 정상적인 응답 처리
//                                do {
//                                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
//                                    let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
//                                    observer(.success(.success(decodedData)))
//                                } catch {
//                                    observer(.success(.failure(error)))
//                                }
//                            default:
//                                // 오류 메시지 처리
//                                if let json = value as? [String: Any], let message = json["message"] as? String {
//                                    print("서버에서 오류 메시지 반환: \(message)")
//                                    let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
//                                    observer(.success(.failure(error)))
//                                } else {
//                                    let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
//                                    observer(.success(.failure(error)))
//                                }
//                            }
//                        }
//                    case .failure(let error):
//                        observer(.success(.failure(error)))
//                    }
//                }
//            } catch {
//                observer(.success(.failure(error)))
//            }
//            return Disposables.create()
//        }
//    }
        func callRequest<T: Decodable>(router: Router, type: T.Type) -> Single<Result<T, Error>> {
            return Single.create { observer -> Disposable in
                do {
                    let request = try router.asURLRequest()
                    AF.request(request).responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let success):
                           print(success,"callrequest")
                            observer(.success(.success(success)))
                        case .failure(let failure):
                            print("fail", failure)
                            observer(.success(.failure(failure)))
                            if response.response?.statusCode == 419 {
                                self.fetchProfile()
                            }
                        }
                    }
                } catch {
                    print(error)
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
    func editProfile(api: Router) {
        do {
            let request = try Router.editProfile.asURLRequest()
            AF.request(request).responseDecodable(of: Profile.self) { response in
                if response.response?.statusCode == 419 {
                    self.refreshToken()
                } else {
                    switch response.result {
                    case .success(let success):
                        print(success)
                        self.fetchProfile()
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        } catch {
            print(error, "EditProfile, URLRequestConvertible 에서 asURLRequest로 요청 만드는 것 실패!")
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
