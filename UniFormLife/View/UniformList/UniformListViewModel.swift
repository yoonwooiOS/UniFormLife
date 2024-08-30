//
//  UniformListViewModel.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/21/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UniformListViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let continentalLeague = Observable.just(["PremierLeague","LaLiga","SerieA","Bundesliga", "League1","KLeague", "Nationalteam"])
    
    private let productID = BehaviorRelay<String>(value: "uniformLife_PremierLeague")
    
    private let nextCursor = BehaviorRelay<String?>(value: nil)
    private let isLoading = BehaviorRelay<Bool>(value: false)
    struct Input {
        let viewdidLoadTrigger: Observable<Void>
        let leagueCellTrigger: Observable<Int>
        let uniformPostTapped:  ControlEvent<PostData>
        let prefetchTrigger: Observable<IndexPath>
    }
    struct Output {
        let uniformListData: BehaviorRelay<[PostData]>
        let continentalLeague: Observable<[String]>
        let uniformPostTapped: PublishRelay<PostData>
        let currentPostDataCount: Observable<Int>
    }
    func transform(input: Input) -> Output {
        let uniformListData = BehaviorRelay<[PostData]>(value: [])
        let selectedPost = PublishRelay<PostData>()
        let currentPostDataCount = uniformListData
            .map { $0.count }
            .distinctUntilChanged()
        Observable.combineLatest(input.viewdidLoadTrigger, productID)
            .flatMapLatest { _, productID in
                NetworkManager.shared.callRequest(router: .fetchPost(productID: productID, cursor: "", limit: "8"), type: FetchPost.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.nextCursor.accept(value.nextCursor)
                    uniformListData.accept(value.data)
                case .failure(let error):
                    print("fetchPostError: \(error)")
                }
            }
            .disposed(by: disposeBag)
        input.prefetchTrigger
            .do(onNext: { _ in
                print("프리패칭")
            })
            .filter {  indexPath in
                if self.nextCursor.value == "0" {
                    return false
                } else {
                    let remainingItems = uniformListData.value.count - indexPath.item
                    return remainingItems <= 12 && self.nextCursor.value != "0" && !self.isLoading.value
                }
            }
            .flatMapLatest { _ in
                self.isLoading.accept(true)
                return NetworkManager.shared.callRequest(router: .fetchPost(productID: self.productID.value, cursor: self.nextCursor.value, limit: "2"), type: FetchPost.self)
            }
            .bind(with: self) { owner, result in
                owner.isLoading.accept(false)
                switch result {
                case .success(let value):
                    print("프리패치 통신중")
                    var currentData = uniformListData.value
                    currentData.append(contentsOf: value.data)
                    uniformListData.accept(currentData)
                    owner.nextCursor.accept(value.nextCursor)
                case .failure(let error):
                    print("fetchPostError: \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        input.leagueCellTrigger
            .bind(with: self, onNext: { onwer, indexPath in
                print(indexPath)
                switch indexPath {
                case 0:
                    return onwer.productID.accept("uniformLife_PremierLeague")
                case 1:
                    return onwer.productID.accept("uniformLife_LaLiga")
                case 2:
                    return onwer.productID.accept("uniformLife_SerieA")
                case 3:
                    return onwer.productID.accept("uniformLife_Bundesliga")
                case 4:
                    return onwer.productID.accept("uniformLife_League1")
                case 5:
                    return onwer.productID.accept("uniformLife_kLeague")
                case 6:
                    return onwer.productID.accept("uniformLife_Nationalteam")
                default:
                    return onwer.productID.accept("uniformLife_PremierLeague")
                }
            })
            .disposed(by: disposeBag)
        input.uniformPostTapped
            .bind(with: self) { owner, postData in
                selectedPost.accept(postData)
            }
            .disposed(by: disposeBag)
        return Output(uniformListData: uniformListData,
                      continentalLeague: continentalLeague,
                      uniformPostTapped: selectedPost,
                      currentPostDataCount: currentPostDataCount)
    }
    
}
