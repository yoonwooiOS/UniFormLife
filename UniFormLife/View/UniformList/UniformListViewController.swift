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
        let view = UICollectionView(frame: .zero, collectionViewLayout: CollectionView.leagueCollectionViewlayout())
        view.register(LeagueFilterCollectionViewCell.self, forCellWithReuseIdentifier: LeagueFilterCollectionViewCell.identifier)
        return view
    }()
    let seperator = {
        let view = UIView()
        view.backgroundColor = Color.lightGray
        return view
    }()
    let uniformListCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: CollectionView.uniformLayout())
        view.register(UniformListCollectionViewCell.self, forCellWithReuseIdentifier: UniformListCollectionViewCell.identifier)
//        view.backgroundColor = .lightGray
        return view
    }()
    let disposeBag = DisposeBag()
    let viewModel = UniformListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.layoutIfNeeded()
        
    }
    override func bind() {
        
        let leagueCellTrigger = leagueCollectionView.rx.itemSelected
            .map{ $0.row }
        let uniformPostTapped = uniformListCollectionView.rx.modelSelected(PostData.self)
        let input = UniformListViewModel.Input(viewdidLoadTrigger: Observable.just(()), leagueCellTrigger: leagueCellTrigger, uniformPostTapped: uniformPostTapped.asObservable())
        let output = viewModel.transform(input: input)
        output.continentalLeague
            .bind(to: leagueCollectionView.rx.items(cellIdentifier: LeagueFilterCollectionViewCell.identifier, cellType: LeagueFilterCollectionViewCell.self)) { (row, element, cell) in
                cell.leagueImageView.image = UIImage(named: element)
            }
            .disposed(by: disposeBag)
        output.uniformListData
            .bind(to: uniformListCollectionView.rx.items(cellIdentifier: UniformListCollectionViewCell.identifier, cellType: UniformListCollectionViewCell.self)) {(row, element, cell) in
                print("Row: \(row), Element: \(element)")
                cell.setUpCell(data: element)
            }
            .disposed(by: disposeBag)
        output.uniformPostTapped
            .bind(with: self) { owner, postData in
                owner.goToOtehrVCwithCompletionHandler(vc: UniformListDetailViewController(), mode: .push) { vc in
                    vc.postData = postData
                }
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
