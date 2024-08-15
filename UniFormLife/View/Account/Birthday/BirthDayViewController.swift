//
//  BirthDayViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class BirthDayViewController: BaseViewController {
    private let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.text = "2022년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "8월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "24일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    private let nextButton = {
        let button = BaseButton(title: "가입하기")
        return button
    }()
    private let disposeBag = DisposeBag()
    override func bind() {
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                print("dasdas")
                owner.goToRootView(rootView: SignInViewController())
            }
            .disposed(by: disposeBag)
    }
    override func setUpHierarchy() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    override func setUpLayout() {
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            make.centerX.equalToSuperview()
        }
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        birthDayPicker.snp.makeConstraints { make in
            make.top.equalTo(containerStackView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
