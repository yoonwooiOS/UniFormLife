//
//  EmailValidViewModel.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/18/24.
//

import Foundation
import RxSwift
import RxCocoa
// 이메일 입력 -> 중북확인 버튼 -> 서버 통신 -> 응답값 -> 보내기
class EmailValidViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String>
        let validButtonTap: ControlEvent<Void>
        let nextButtonTap: ControlEvent<Void>
    }
    struct Output {
        let nextButtonTap: ControlEvent<Void>
        let validText: Observable<Bool>
        let eamilValid: PublishRelay<Bool>
    }
    func transfrom(input: Input) -> Output {
        let validText = input.emailText
            .map { $0.count > 7 && $0.contains("@")}
        let emailValid = PublishRelay<Bool>()
        
        input.validButtonTap
                    .withLatestFrom(validText)
                    .filter { $0 }
                    .withLatestFrom(input.emailText)
                    .bind(with: self) { owner, email in
                        print("Validating email:", email)
                        NetworkManager.callRequest(router: .validateEmail(email: email)) { (result: Result<ValidEmail, Error>) in
                            switch result {
                            case .success(let value):
                                dump(value)
                                if value.message == "사용 가능한 이메일입니다." {
                                    emailValid.accept(true)
                                } else {
                                    emailValid.accept(false)
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    .disposed(by: disposeBag)
        return Output(nextButtonTap: input.nextButtonTap, validText: validText, eamilValid: emailValid)
    }
}
