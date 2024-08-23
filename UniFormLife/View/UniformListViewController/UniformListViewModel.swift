//
//  UniformListViewModel.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/21/24.
//

import Foundation
import RxSwift
import RxCocoa

class UniformListViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let continentalLeague = Observable.just(["pl","llg","il","pl1", "kl", "kr","pl","llg","il","pl1", "kl", "kr"])
    struct Input {
        let viewdidLoadTrigger: Observable<Void>
    }
    struct Output {
        let uniformListData: PublishRelay<[PostData]>
        let continentalLeague: Observable<[String]>
    }
    func transfrom(input: Input) -> Output {
        let uniformListData = PublishRelay<[PostData]>()
        input.viewdidLoadTrigger
            .do(onNext: {
                   print("viewdidLoadTrigger was triggered")
               })
            .flatMapLatest {
                NetworkManager.shared.callRequest(router: .fetchPost(productID: "ligue1"), type: FetchPost.self)
                          .do(onSuccess: { result in
                              print(result,"dasdsad")
                          })
                  }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print(value,"😍😍😍😍😍😍😍")
                    uniformListData.accept(value.data)
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            .disposed(by: disposeBag)
        return Output(uniformListData: uniformListData, continentalLeague: continentalLeague)
    }
    
}
