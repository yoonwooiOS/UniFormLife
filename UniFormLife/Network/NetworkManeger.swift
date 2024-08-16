//
//  NetworkManager.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import Foundation
import Alamofire
import RxSwift

struct NetworkManager {
    private init() { }
    static func loginUser(email: String, password: String, loginCompletionHandler: @escaping (Result<LoginModel, Error>) -> Void) -> Void {
        do {
            let query = LoginQuery(email: email, password: password)
            let request = try Router.login(query: query).asURLRequest()
            AF.request(request).responseDecodable(of: LoginModel.self) { response in
                switch response.result{
                case .success(let success):
                    //                        print(success)
                    UserDefaultsManeger.shared.token = success.access
                    UserDefaultsManeger.shared.refreshToken = success.refresh
                    loginCompletionHandler(.success(success))
                    //                      goToRootView(rootView: )
                case .failure(let failure):
                    print("fail", failure)
                    if response.response?.statusCode == 419 {
                        //                             토큰 갱신
                        self.fetchProfile()
                    }
                    loginCompletionHandler(.failure(failure))
                }
                
            }
        } catch {
            print(error)
        }
    }
    static func fetchProfile() {
        // let request = try! Router.fetchProfile.asURLRequest()
        do {
            let request = try Router.fetchProfile.asURLRequest()
            AF.request(request).responseDecodable(of: ProfileModel.self) { response in
                if response.response?.statusCode == 419 {
                    self.refreshToken()
                } else {
                    switch response.result {
                    case .success(let success):
                        print(success)
                        //                        self.profileView.emailLabel.text = success.email
                        //                        self.profileView.userNameLabel.text = success.nick
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        } catch {
            print(error, "fetchProfile, URLRequestConvertible 에서 asURLRequest로 요청 만드는 것 실패!")
        }
    }
    static func editProfile(api: Router) {
        do {
            let request = try Router.editProfile.asURLRequest()
            AF.request(request).responseDecodable(of: ProfileModel.self) { response in
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
    static func refreshToken() {
        do {
            let request = try Router.refresh.asURLRequest()
            AF.request(request).responseDecodable(of: RefreshModel.self) { response in
                if response.response?.statusCode == 418 {
                    //rootViewController를 LoginViewController 전환 -> 로그인 해서 새로운 토큰 발급
                    //UserDefaults 제거
                    
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
//enum APIError: Error {
//    case invalidURL
//    case unknownRespose
//    case statusError
//}
//class NetworkManagers {
//    static let shared = NetworkManagers()
//    private init () { }
//    func createLogin(email: String, password: String) -> Single<Result<LoginModel,APIError>> {
//        return Single.create { observer -> Disposable in
//            do {
//                let query = LoginQuery(email: email, password: password)
//                let request = try Router.login(query: query).asURLRequest()
////                print(request.httpBody)
//                print(email,password)
//                AF.request(request)
//    //                .responseString(completionHandler: { value in
//    //                    print(value)
//    //                })
//                    .responseDecodable(of: LoginModel.self) { response in
//                        switch response.result{
//                        case .success(let success):
//                            print(success)
//    //                        UserDefaultsManeger.shared.token = success.access
//    //                        UserDefaultsManeger.shared.refreshToken = success.refresh
//    //                        let vc = ProfileViewController()
//    //                        setRootViewController(vc)
//                        case .failure(let failure):
//                            print("fail", failure)
//                            if response.response?.statusCode == 419 {
//    //                             토큰 갱신
////                                self.fetchProfile()
//                            }
//                        }
//                    }
//            } catch {
//                print(error)
//            }
//            return Disposables.create()
//        }
//    }
//
//    func fetchProfile() {
//
//            // let request = try! Router.fetchProfile.asURLRequest()
//
//    }
//}
