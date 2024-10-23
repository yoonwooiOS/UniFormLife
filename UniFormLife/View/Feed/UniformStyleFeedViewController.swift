//
//  UniformStyleFeedViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class UniformStyleFeedViewController: BaseViewController {
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionView.UniformStyleFeedLayout()).then {
        $0.register(UniformStyleFeedCollectionViewCell.self, forCellWithReuseIdentifier: UniformStyleFeedCollectionViewCell.identifier)
    }
    
    // 더미 데이터
    let items = Observable.of([
        FeedModel(
            username: "Son7",
            description: "바다갈 땐 시티 옷이 딱이지",
            followerCount: 169.8,
            profileImage: "son",
            images: ["feedex", "feedex2", "feedex3"]
        ),
        FeedModel(
            username: "폼생폼사",
            description: "찰칵~ ✌🏻",
            followerCount: 200.8,
            profileImage: "son",
            images: ["feedex2", "feedex3", "feedex4"]
        ),
        FeedModel(
            username: "안녕하시렵니까",
            description: "킴!!",
            followerCount: 150.3,
            profileImage: "son",
            images: ["feedex3", "feedex4", "feedex"]
        ),
        FeedModel(
            username: "칼있나",
            description: "ㅇㄴ러ㅣㄴ어리ㅓㄴㅇ리ㅏ넘ㅇ리ㅏ너아ㅣ러ㅣㄴ어라ㅣ너이ㅏ러니아ㅓ라ㅣㄴ어리ㅏ",
            followerCount: 180.5,
            profileImage: "son",
            images: ["feedex4", "feedex", "feedex2"]
        )
    ])
    
    // MARK: - Lifecycle
    override func setUpHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func setUpLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setUpNavigationTitle() {
        if let font = UIFont(name: "YoonChildfundkoreaManSeh", size: 26) {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: font
            ]
        }
        navigationItem.title = "Form생Form사"
    }
    
    override func bind() {
        items
            .bind(to: collectionView.rx.items(
                cellIdentifier: UniformStyleFeedCollectionViewCell.identifier,
                cellType: UniformStyleFeedCollectionViewCell.self)
            ) { [weak self] index, model, cell in
                cell.configure(with: model)
                
                cell.bookmarkButton.rx.tap
                    .subscribe(onNext: {
                        print("좋아요 버튼 탭: \(index)")
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                print("선택된 셀: \(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }
}



// MARK: - Model
struct FeedModel {
    let username: String
    let description: String
    let followerCount: Double
    let profileImage: String
    let images: [String]
}
