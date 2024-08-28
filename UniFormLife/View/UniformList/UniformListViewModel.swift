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
    private let continentalLeague = Observable.just(["PremierLeague","LaLiga","SerieA","League1","KLeague", "Nationalteam"])
   
    private let productID = BehaviorRelay<String>(value: "uniformLife_PremierLeague")
    struct Input {
        let viewdidLoadTrigger: Observable<Void>
        let leagueCellTrigger: Observable<Int>
        let uniformPostTapped: Observable<PostData>
    }
    struct Output {
        let uniformListData: PublishRelay<[PostData]>
        let continentalLeague: Observable<[String]>
        let uniformPostTapped: PublishRelay<PostData>
    }
    func transform(input: Input) -> Output {
        let uniformListData = PublishRelay<[PostData]>()
        let selectedPost = PublishRelay<PostData>()
        Observable.combineLatest(input.viewdidLoadTrigger, productID)
                   .flatMapLatest { _, productID in
                       NetworkManager.shared.callRequest(router: .fetchPost(productID: productID), type: FetchPost.self)
                   }
                   .bind(with: self) { owner, result in
                       switch result {
                       case .success(let value):
                           uniformListData.accept(value.data)
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
                    return onwer.productID.accept("uniformLife_League1")
                case 4:
                    return onwer.productID.accept("uniformLife_kLeague")
                case 5:
                    return onwer.productID.accept("uniformLife_otherUniforms")
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
        return Output(uniformListData: uniformListData, continentalLeague: continentalLeague, uniformPostTapped: selectedPost)
    }
    
}
