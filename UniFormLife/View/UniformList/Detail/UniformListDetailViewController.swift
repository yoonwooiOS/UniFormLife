//
//  UniformListDetailViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class UniformListDetailViewController: BaseViewController {
    var postData: PostData?
    private let imageNames = ["man1", "man2", "man3"]
    private let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
    }
    private let pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.pageIndicatorTintColor = .lightGray
        $0.currentPageIndicatorTintColor = .black
    }
    private let userProfileBaseView = UIView().then {
        $0.backgroundColor = .blue
    }
    private let userProfileImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    private lazy var userNicknameLabel = UILabel().then {
        $0.text = postData?.creator.nick
    }
    private let likeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.tintColor = Color.lightGray
    }
    private let disposeBag = DisposeBag()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImages()
        setUpImageBinding()
    }
    override func bind() {
        scrollView.rx.contentOffset
            .map { Int($0.x / self.view.frame.width) } // 현재 페이지 인덱스 계산
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
    }
    override func setUpHierarchy() {
        [scrollView, pageControl, userProfileBaseView].forEach {
            view.addSubview($0)
        }
        [userProfileImageView, userNicknameLabel, likeButton].forEach {
            userProfileBaseView.addSubview($0)
        }
    }
    override func setUpLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.frame.height * 0.4)
        }
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).inset(24)
            make.centerX.equalToSuperview()
        }
        userProfileBaseView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(4)
            make.height.equalTo(60)
        }
        
    }
    
    private func setUpImages() {
        var previousImageView: UIImageView? = nil
        for (_, imageName) in imageNames.enumerated() {
            let imageView = UIImageView().then {
                $0.image = UIImage(named: imageName)
                $0.contentMode = .scaleToFill
                $0.clipsToBounds = true
            }
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(view)
                make.height.equalTo(scrollView)
                if let previous = previousImageView {
                    make.leading.equalTo(previous.snp.trailing)
                } else {
                    make.leading.equalToSuperview()
                }
            }
            previousImageView = imageView
        }
        previousImageView?.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
        pageControl.numberOfPages = imageNames.count
    }
    
    private func setUpImageBinding() {
        scrollView.rx.contentOffset
            .map { Int($0.x / self.view.frame.width) } // 현재 페이지 인덱스 계산
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
    }
}
