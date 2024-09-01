//
//  NetworkInterceptor.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/31/24.
//

import Alamofire
import Foundation
import RxSwift
import UIKit

class NetworkInterceptor: RequestInterceptor {
    let disposeBag = DisposeBag()
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("======어탭트 실행======")
        var request = urlRequest
        let token = UserDefaultsManeger.shared.token
        if !token.isEmpty {
            request.setValue(token, forHTTPHeaderField: Header.authorization.rawValue)
        }
        request.setValue(APIKey.key, forHTTPHeaderField: Header.sesacKey.rawValue)
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("리트라이 실행")
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        if statusCode == 419 || statusCode == 403 {
            refreshToken { isSuccess in
                if isSuccess {
                    completion(.retry)
                } else {
                    completion(.doNotRetryWithError(error))
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        NetworkService.shared.refreshToken()
            .subscribe { refresh in
                switch refresh {
                case .success(let refreshToken):
                    UserDefaultsManeger.shared.token = refreshToken.accessToken
                    print("인터셉터 리프레시로 로큰갱신")
                    completion(true)
                case .failure:
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    sceneDelegate?.window?.rootViewController = SignInViewController()
                    sceneDelegate?.window?.makeKeyAndVisible()
                    completion(false)
                }
            }
            .disposed(by: disposeBag)
    }
    
}

