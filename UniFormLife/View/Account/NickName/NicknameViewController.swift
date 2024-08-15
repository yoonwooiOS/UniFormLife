//
//  NicknameViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class NicknameViewController: BaseViewController {
    private let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    private let nextButton = BaseButton(title: "다음")
    private let nicknameStateLabel = UILabel()
    private let disposeBag = DisposeBag()
    override func bind() {
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                print("dsdsa")
                owner.goToOtehrVC(vc: BirthDayViewController(), mode: .push)
            }
            .disposed(by: disposeBag)
    }
    override func setUpHierarchy() {
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameStateLabel)
        view.addSubview(nextButton)
    }
    override func setUpLayout() {
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nicknameStateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameStateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

