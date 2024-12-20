//
//  SignInViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignInViewController: BaseViewController {
    private let emailTextField = {
        let view = SignTextField(placeholderText: "이메일을 입력해주세요")
        view.text = "yw1@test.com"
        return view
    }()
    private let passwordTextField = {
        let view = SignTextField(placeholderText: "비밀번호를 입력해주세요")
        view.text = "12345"
        return view
    }()
    private let signInButton = BaseButton(title: "로그인")
    private let signUpButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(Color.gray, for: .normal)
        button.titleLabel?.font = Font.regular14
        return button
    }()
    deinit {
        print("\(self)")
    }
    private let disposeBag = DisposeBag()
    let signInViewModel = SignInViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func bind() {
            
        let input = SignInViewModel.Input(signInButtonTap: signInButton.rx.tap, signUpButtonTap: signUpButton.rx.tap, eamilText: emailTextField.rx.text.orEmpty, passwordText: passwordTextField.rx.text.orEmpty)
        
        let output = signInViewModel.transform(input: input)
   
        output.createLoginValid
            .bind(with: self, onNext: { owner, result in
                switch result {
                case .success(_):
                    owner.goToRootView(rootView: HomeTabBarController())
                case .failure(_):
                    owner.showBasicAlert("아이디, 비밀번호를 확인해주세요!")
                }
            })
            .disposed(by: disposeBag)
        output.signUpButtonTap
            .bind(with: self) { owner, _ in
                owner.goToOtehrVC(vc: EmailValidViewController(), mode: .push)
            }
            .disposed(by: disposeBag)
    }
    override func setUpHierarchy() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
    }
    override func setUpLayout() {
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
