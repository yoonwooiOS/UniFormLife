//
//  UniformListViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class UniformListViewController: BaseViewController {
    let leagueCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        view.register(LeagueFilterCollectionViewCell.self, forCellWithReuseIdentifier: LeagueFilterCollectionViewCell.identifier)
//        view.backgroundColor = .brown
        return view
    }()
    let seperator = {
        let view = UIView()
        view.backgroundColor = Color.lightGray
        return view
    }()
    let uniformListCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: uniformLayout())
        view.register(UniformListCollectionViewCell.self, forCellWithReuseIdentifier: UniformListCollectionViewCell.identifier)
        view.backgroundColor = .brown
        return view
    }()
    static func layout() -> UICollectionViewLayout {
        let sectionSpacing: CGFloat = 12
        let cellSpacing: CGFloat = 8
//        let size = UIScreen.main.bounds.width -  (cellSpacing)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .horizontal // 가로 간격
        layout.minimumLineSpacing = cellSpacing // 세로 간격
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    static func uniformLayout() -> UICollectionViewLayout {
        let sectionSpacing: CGFloat = 12
        let cellSpacing: CGFloat = 8
//        let size = UIScreen.main.bounds.width -  (cellSpacing)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 360, height: 160)
        layout.scrollDirection = .vertical // 가로 간격
        layout.minimumLineSpacing = cellSpacing // 세로 간격
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    let disposeBag = DisposeBag()
    var list = Observable.just(["pl","llg","il","pl1", "kl", "kr","pl","llg","il","pl1", "kl", "kr"])
    var listdata = PublishRelay<[FetchPost]>()
    let viewModel = UniformListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func bind() {
        let input = UniformListViewModel.Input(viewdidLoadTrigger: Observable.just(()))
        let output = viewModel.transfrom(input: input)
        
        list
            .bind(to: leagueCollectionView.rx.items(cellIdentifier: LeagueFilterCollectionViewCell.identifier, cellType: LeagueFilterCollectionViewCell.self)) { (row, element, cell) in
                
                cell.leagueImageView.image = UIImage(named: element)
                
            }
            .disposed(by: disposeBag)
        output.uniformListData
            .bind(to: uniformListCollectionView.rx.items(cellIdentifier: UniformListCollectionViewCell.identifier, cellType: UniformListCollectionViewCell.self)) {(row, element, cell) in
                cell.titleLabel.text = element.title
                
            }
            .disposed(by: disposeBag)
    }
    override func setUpHierarchy() {
        view.addSubview(leagueCollectionView)
        view.addSubview(seperator)
        view.addSubview(uniformListCollectionView)
    }
    override func setUpLayout() {
        leagueCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(80)
        }
        seperator.snp.makeConstraints { make in
            make.top.equalTo(leagueCollectionView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(1)
        }
        uniformListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(leagueCollectionView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func setUpNavigationTitle() {
        navigationItem.title = "폼생폼사"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
