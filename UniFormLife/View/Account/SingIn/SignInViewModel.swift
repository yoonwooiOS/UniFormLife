//
//  SignInViewModel.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel: ViewModelType {
   let disposeBag = DisposeBag()
    struct Input {
        let signInButtonTap: ControlEvent<Void>
        let signUpButtonTap: ControlEvent<Void>
        let eamilText: ControlProperty<String>
        let passwordText: ControlProperty<String>
    }
    struct Output {
        let createLoginValid: PublishSubject<Result<LoginModel, Error>>
        let signUpButtonTap: ControlEvent<Void>
    }
    
    func transfrom(input: Input) -> Output {
        let eamilText = BehaviorRelay<String>(value: "")
        let passwordText = BehaviorRelay<String>(value: "")
        let createLoginValid = PublishSubject<Result<LoginModel, Error>>()
        input.eamilText
            .bind { text in
                eamilText.accept(text)
            }
            .disposed(by: disposeBag)
        input.passwordText
            .bind { text in
                passwordText.accept(text)
            }
            .disposed(by: disposeBag)
        input.signInButtonTap
            .bind(with: self) { owner, _ in
                print(eamilText.value)
                print(passwordText.value)
                NetworkManager.loginUser(email: eamilText.value, password: passwordText.value) { result in
                    switch result {
                    case .success(let value):
                        dump(value)
                        createLoginValid.onNext(.success(value))
                    case .failure(let error):
                        print(error)
                        createLoginValid.onNext(.failure(error))
                    }
                }
            }
            .disposed(by: disposeBag)
        return Output(createLoginValid: createLoginValid, signUpButtonTap: input.signUpButtonTap)
    }
    
}
