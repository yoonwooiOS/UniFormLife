//
//  PasswordViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PasswordViewController: BaseViewController {
    private let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    private let nextButton = BaseButton(title: "다음")
    private let stateLabel = {
        let label = UILabel()
        return label
    }()
    private let disposeBag = DisposeBag()
    override func bind() {
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                print("dsdsa")
                owner.goToOtehrVC(vc: NicknameViewController(), mode: .push)
            }
            .disposed(by: disposeBag)
    }
    override func setUpHierarchy() {
        view.addSubview(passwordTextField)
        view.addSubview(stateLabel)
        view.addSubview(nextButton)
    }
    override func setUpLayout() {
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(stateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
