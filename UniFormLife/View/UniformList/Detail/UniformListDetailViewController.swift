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
    
    private let baseScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.bounces = true
    }
    
    private let contentView = UIView()
    
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
    private let userProfileBaseView = UIView().then { _ in }
    private let userProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "son")
//        $0.backgroundColor = .green
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
    }
    private lazy var userNicknameLabel = UILabel().then {
        $0.text = postData?.creator.nick
        $0.font = Font.bold14
        //        $0.backgroundColor = .blue
    }
    private let likeButton = UIButton().then {
        $0.tintColor = Color.black
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .large)
        $0.setImage(UIImage(systemName: "heart", withConfiguration: largeConfig), for: .normal)
    }
    private let followersLabel = UILabel().then {
        $0.text = "팔로워 184명"
        $0.textColor = Color.gray
        $0.font = Font.regular12
    }
    private let postCount = UILabel().then {
        $0.text = "게시글 30개"
        $0.textColor = Color.gray
        $0.font = Font.regular12
    }
    private let seperator = {
        let view = UIView()
        view.backgroundColor = Color.lightGray
        return view
    }()
    private let mainBaseView = UIView().then { _ in
//        $0.backgroundColor = .green
    }
    private lazy var postTitle = UILabel().then {
        $0.font = Font.bold18
        $0.numberOfLines = 0
    }
    private lazy var content = UILabel().then {
        $0.font = Font.regular14
        $0.numberOfLines = 0
    }
    private let usedLabel = AddPaddingLabel().then { _ in }
    private let sizeLabel = AddPaddingLabel().then { _ in }
    private let yearLabel = AddPaddingLabel().then { _ in }
    private let disposeBag = DisposeBag()
    
    private let viewModel = UniformListDetailViewModel()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImages()
        setUpImageBinding()
        guard let postData else { return }
        postTitle.text = postData.title
        content.text = postData.content
        usedLabel.text = postData.content1
        sizeLabel.text = postData.content2
        yearLabel.text = postData.content3
        print(postData.post_id)
    }
    
    override func bind() {
        let input = UniformListDetailViewModel.Input(likeButtonTapped: likeButton.rx.tap)
        let output = viewModel.transform(input: input)
        output.isLiked
            .bind(with: self, onNext: { owner, isLiked in
//                print(isLiked)
                let imageName = isLiked ? "heart.fill" : "heart"
                owner.likeButton.setImage(UIImage(systemName: imageName), for: .normal)
                owner.likeButton.tintColor = isLiked ? .red : .lightGray
            })
            .disposed(by: disposeBag)
        
        scrollView.rx.contentOffset
            .map { Int($0.x / self.view.frame.width) }
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
    }
    
    override func setUpHierarchy() {
        [baseScrollView, seperator, mainBaseView].forEach {
            view.addSubview($0)
        }
        baseScrollView.addSubview(contentView)
        [scrollView, pageControl, userProfileBaseView].forEach {
            contentView.addSubview($0)
        }
        [userProfileImageView, userNicknameLabel, likeButton, followersLabel, postCount].forEach {
            userProfileBaseView.addSubview($0)
        }
        [postTitle,content, usedLabel, sizeLabel, yearLabel].forEach {
            mainBaseView.addSubview($0)
        }
    }
    
    override func setUpLayout() {
        let baseOffset = 8
        baseScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.frame.height * 0.4)
        }
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).inset(24)
            make.centerX.equalToSuperview()
        }
        userProfileBaseView.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(baseOffset)
            make.horizontalEdges.equalToSuperview().inset(4)
            make.height.equalTo(68)
        }
        userProfileImageView.snp.makeConstraints { make in
            make.leading.equalTo(userProfileBaseView).offset(baseOffset)
            make.centerY.equalTo(userProfileBaseView)
            make.size.equalTo(60)
        }
        userNicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(7)
            make.top.equalTo(userProfileImageView.snp.top)
        }
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(userProfileBaseView).inset(baseOffset)
            make.centerY.equalTo(userProfileImageView)
            make.size.equalTo(56)
        }
        followersLabel.snp.makeConstraints { make in
            make.top.equalTo(userNicknameLabel.snp.bottom).offset(2)
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(baseOffset)
        }
        postCount.snp.makeConstraints { make in
            make.top.equalTo(followersLabel.snp.bottom).offset(2)
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(baseOffset)
        }
        seperator.snp.makeConstraints { make in
            make.top.equalTo(userProfileBaseView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(baseOffset)
            make.height.equalTo(1)
        }
        mainBaseView.snp.makeConstraints { make in
            make.top.equalTo(seperator.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        postTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().offset(baseOffset)
            
        }
        usedLabel.snp.makeConstraints { make in
            make.top.equalTo(postTitle.snp.bottom).offset(baseOffset)
            make.leading.equalToSuperview().offset(baseOffset)
        }
        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(postTitle.snp.bottom).offset(baseOffset)
            make.leading.equalTo(usedLabel.snp.trailing).offset(4)
        }
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(postTitle.snp.bottom).offset(baseOffset)
            make.leading.equalTo(sizeLabel.snp.trailing).offset(4)
        }
        content.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(baseOffset)
            make.horizontalEdges.equalToSuperview().offset(baseOffset)
        }
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(userProfileBaseView.snp.bottom).offset(500)
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
            .map { Int($0.x / self.view.frame.width) }
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
    }
}
