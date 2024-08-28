//
//  EmailViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EmailValidViewController: BaseViewController {
    private let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    private let validationButton = {
        let button = UIButton()
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(Color.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = Color.black.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    private let eamilStateLabel = {
        let label = UILabel()
        return label
    }()
    private var nextButton = {
        let button = BaseButton(title: "다음")
        button.isEnabled = true
        return button
    }()
    private let disposeBag = DisposeBag()
    let viewModel = EmailValidViewModel()
    override func bind() {
        let input = EmailValidViewModel.Input(emailText: emailTextField.rx.text.orEmpty, validButtonTap: validationButton.rx.tap , nextButtonTap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.validText
            .bind(with: self) { owner, value in
                switch value {
                case true:
                    owner.eamilStateLabel.text = "사용 가능한 이메일 입니다."
                    owner.eamilStateLabel.textColor = .systemBlue
                case false:
                    owner.eamilStateLabel.text = "이메일은 7글자 이상 @을 포합해야합니다."
                    owner.eamilStateLabel.textColor = .systemRed
                }
            }
            .disposed(by: disposeBag)
        output.eamilValid
            .bind(with: self) { owner, value in
                switch value {
                case true:
                    owner.showBasicAlert("사용 가능한 이메일입니다!")
                    owner.nextButton.isEnabled = !value
                case false:
                    owner.showBasicAlert("중복된 이메일입니다!")
                    owner.eamilStateLabel.text = "중복된 이메일입니다. 다시 입력해주세요"
                    owner.eamilStateLabel.textColor = .systemRed
//                    owner.nextButton.isEnabled = value
                }
            }
            .disposed(by: disposeBag)
        output.nextButtonTap
            .bind(with: self) { owner, _ in
                print("dsdsa")
                owner.goToOtehrVC(vc: PasswordViewController(), mode: .push)
            }
            .disposed(by: disposeBag)
    }
    override func setUpHierarchy() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(eamilStateLabel)
        view.addSubview(nextButton)
    }
    override func setUpLayout() {
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        eamilStateLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(eamilStateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
