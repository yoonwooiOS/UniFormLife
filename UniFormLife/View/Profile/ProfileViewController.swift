//
//  ProfileViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/16/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ProfileViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let settingsButton = UIButton().then {
        $0.setImage(UIImage(systemName: "gearshape"), for: .normal)
    }
    
    private let shareButton = UIButton().then {
        $0.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
    }
    
    private let cartButton = UIButton().then {
        $0.setImage(UIImage(systemName: "cart"), for: .normal)
        
    }
    
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 40
        $0.clipsToBounds = true
    }
    
    private let usernameLabel = UILabel().then {
        $0.text = "WWIT"
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    private let followerInfoLabel = UILabel().then {
        $0.text = "팔로워 1  팔로잉 2"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    // UISegmentedControl 생성
    private let segmentedControl = UISegmentedControl(items: ["게시물", "스크랩북 17", "좋아요 2"]).then {
        $0.selectedSegmentIndex = 0
        $0.selectedSegmentTintColor = .black
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 기본 세그먼트(게시물) 내용 표시
        showContent(for: .posts)
    }
    
    // MARK: - UI 구성
    override func setUpHierarchy() {
        view.backgroundColor = .white
        
        [settingsButton, shareButton, cartButton, profileImageView, usernameLabel,
         followerInfoLabel, segmentedControl, contentView].forEach {
            view.addSubview($0)
        }
    }

    override func setUpLayout() {
        settingsButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        shareButton.snp.makeConstraints {
            $0.centerY.equalTo(settingsButton)
            $0.trailing.equalTo(cartButton.snp.leading).offset(-15)
        }
        
        cartButton.snp.makeConstraints {
            $0.centerY.equalTo(settingsButton)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(settingsButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(80)
        }
        
        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        
        followerInfoLabel.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(usernameLabel)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Bindings 설정
    override func bind() {
        segmentedControl.rx.selectedSegmentIndex
            .bind { [weak self] index in
                guard let self = self else { return }
                self.showContent(for: ContentType(rawValue: index) ?? .posts)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - 컨텐츠 표시
    private enum ContentType: Int {
        case posts = 0
        case scraps = 1
        case likes = 2
    }
    
    private func showContent(for type: ContentType) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        label.textAlignment = .center
        
        switch type {
        case .posts:
            label.text = "게시물 내용"
        case .scraps:
            label.text = "스크랩북 내용"
        case .likes:
            label.text = "좋아요 내용"
        }
        
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
