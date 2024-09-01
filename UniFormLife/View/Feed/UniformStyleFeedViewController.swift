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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionView.UniformStyleFeedLayout()).then {
//        $0.backgroundColor = .systemGreen
        $0.register(UniformStyleFeedCollectionViewCell.self, forCellWithReuseIdentifier: UniformStyleFeedCollectionViewCell.identifier)
    }
    let disposeBag = DisposeBag()
    let items = Observable.of([
        "Son7",
        "폼생폼사",
        "안녕하시렵니까",
        "칼있나"
    ])
    
    override func setUpHierarchy() {
        view.addSubview(collectionView)
    }
    override func setUpLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func setUpNavigationTitle() {
        navigationItem.title = "Form생 Form사"
    }
    override func bind() {
        items.bind(to: collectionView.rx.items(cellIdentifier: UniformStyleFeedCollectionViewCell.identifier, cellType: UniformStyleFeedCollectionViewCell.self)) { index, item, cell in
            cell.usernameLabel.text = item
            cell.profileImageView.image = UIImage(named: "son")
            if index == 0 {
                cell.postImageView.image = UIImage(named: "feedex")
                cell.titleLabel.text = "바다갈 땐 시티 옷이 딱이지"
            } else if index == 1 {
                cell.postImageView.image = UIImage(named: "feedex2")
                cell.titleLabel.text = "찰칵~ ✌🏻"
            } else if index == 2{
                cell.postImageView.image = UIImage(named: "feedex3")
                cell.titleLabel.text = "킴!!"
            } else if index == 3{
                cell.postImageView.image = UIImage(named: "feedex4")
                cell.titleLabel.text = "ㅇㄴ러ㅣㄴ어리ㅓㄴㅇ리ㅏ넘ㅇ리ㅏ너아ㅣ러ㅣㄴ어라ㅣ너이ㅏ러니아ㅓ라ㅣㄴ어리ㅏ"
            } else {
                cell.postImageView.image = UIImage(named: "feedex4")
                cell.titleLabel.text = "ㅇㄴ러ㅣㄴ어리ㅓㄴㅇ리ㅏ넘ㅇ리ㅏ너아ㅣ러ㅣㄴ어라ㅣ너이ㅏ러니아ㅓ라ㅣㄴ어리ㅏ"
            }
            
        }
        .disposed(by: disposeBag)
    }
}
