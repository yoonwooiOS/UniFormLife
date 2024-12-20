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
    //
    private let imageNamesSubject = BehaviorSubject<[String]>(value: [])
    
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
        $0.currentPageIndicatorTintColor = .white
        
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
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .large)
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
        $0.font = Font.bold21
        $0.numberOfLines = 0
    }
    private lazy var content = UILabel().then {
        $0.font = Font.regular16
        $0.numberOfLines = 0
    }
    private let usedLabel = AddPaddingLabel()
    private let sizeLabel = AddPaddingLabel()
    private let yearLabel = AddPaddingLabel()
    private let paymentButton = BaseButton(title: "구매하기")

    private let bottonBaseView = UIView().then {
        $0.backgroundColor = Color.white
    }
    private lazy var reccomandUserNameLabel = UILabel().then {
        if let nickName =  postData?.creator.nick  {
            $0.text = "\(nickName)님의 다른 게시물"
        }
        $0.font = Font.bold18
    }
    private let recommandCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionView.recommandCollectionViewLayout()).then {
        $0.register(DetailViewRecommandCollectionViewCell.self, forCellWithReuseIdentifier: DetailViewRecommandCollectionViewCell.identifier)
        $0.showsHorizontalScrollIndicator = false
    }
    private let disposeBag = DisposeBag()
    private let viewModel = UniformListDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImageBinding()
    }

    override func bind() {
        let input = UniformListDetailViewModel.Input(likeButtonTapped: likeButton.rx.tap, paymentButtonTapped: paymentButton.rx.tap, postData: postData)
        let output = viewModel.transform(input: input)
        output.isLiked
            .bind(with: self, onNext: { owner, isLiked in
                let imageName = isLiked ? "heart.fill" : "heart"
                owner.likeButton.setImage(UIImage(systemName: imageName), for: .normal)
                owner.likeButton.tintColor = isLiked ? .red : .lightGray
            })
            .disposed(by: disposeBag)

        output.paymentButtonTapped
            .bind(with: self) { owner, _ in
                owner.goToOtehrVCwithCompletionHandler(vc: PaymentViewController(), mode: .push, tabbarHidden: true) { vc in
                    vc.postData = owner.postData
                    
                }
            }
            .disposed(by: disposeBag)
    
        output.fetchUserPost
            .bind(to: recommandCollectionView.rx.items(cellIdentifier: DetailViewRecommandCollectionViewCell.identifier, cellType: DetailViewRecommandCollectionViewCell.self)) { (row, element, cell) in
                print(element, "output.fetchUserPost Element")
                let data = element
                cell.setUpCell(data: data)
                
            }
            .disposed(by: disposeBag)
        
    }
    private func setUpImageBinding() {
        guard let postData else { return }
        imageNamesSubject.onNext(postData.files)
        imageNamesSubject
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, images in
                owner.setUpImages(with: images)
            })
            .disposed(by: disposeBag)
        
        scrollView.rx.contentOffset
            .map { Int($0.x / self.view.frame.width) }
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
    }
    override func setUpHierarchy() {
        [baseScrollView, seperator, bottonBaseView].forEach {
            view.addSubview($0)
        }
        [contentView,mainBaseView,recommandCollectionView, reccomandUserNameLabel].forEach {
            baseScrollView.addSubview($0)
        }
        [scrollView, pageControl, userProfileBaseView].forEach {
            contentView.addSubview($0)
        }
        [userProfileImageView, userNicknameLabel, likeButton, followersLabel, postCount].forEach {
            userProfileBaseView.addSubview($0)
        }
        [postTitle,content, usedLabel, sizeLabel, yearLabel].forEach {
            mainBaseView.addSubview($0)
        }
        bottonBaseView.addSubview(paymentButton)
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
            make.top.equalToSuperview()
//            make.top.equalTo(contentView.snp.top)
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
            make.top.equalTo(yearLabel.snp.bottom).offset(baseOffset).offset(8)
            make.horizontalEdges.equalToSuperview().inset(baseOffset)
            
        }
        reccomandUserNameLabel.snp.makeConstraints { make in
            make.top.equalTo(content.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(baseOffset)
        }
        recommandCollectionView.snp.makeConstraints { make in
            make.top.equalTo(reccomandUserNameLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(baseOffset)
            make.height.equalTo(240)
            make.bottom.equalToSuperview().offset(-60)
        }
        bottonBaseView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(80)
            make.bottom.equalToSuperview()
        }
        paymentButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(baseOffset)
           
        }
        //        contentView.snp.makeConstraints { make in
        //            make.bottom.equalTo(userProfileBaseView.snp.bottom).offset(900)
        //        }
        
    }
    override func setUpView() {
        guard let postData else { return }
        postTitle.text = postData.title
        content.text = postData.content
        usedLabel.text = postData.content1
        sizeLabel.text = postData.content2
        yearLabel.text = postData.content3
    }
    private func setUpImages(with imageNames: [String]) {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        var previousImageView: UIImageView? = nil
        for (_, imageName) in imageNames.enumerated() {
            let imageView = UIImageView().then {
                $0.setDownloadToImageView(urlString: imageName)
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
        updatePageControl(imageNames: imageNames)
    }
    private func updatePageControl(imageNames: [String]) {
        pageControl.numberOfPages = imageNames.count
        pageControl.isHidden = imageNames.count <= 1
    }
    override func setUpNavigationTitle() {
        if let font = UIFont(name: "YoonChildfundkoreaManSeh", size: 20) {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: font,
//                NSAttributedString.Key.foregroundColor: UIColor.systemBlue
            ]
        } else {
            print("폰트를 로드할 수 없습니다. 폰트 이름을 확인하세요.")
        }
        navigationItem.title = "프리미어리그"
    }
}
