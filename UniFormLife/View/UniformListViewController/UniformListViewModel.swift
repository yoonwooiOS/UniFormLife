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
    struct Input {
        let viewdidLoadTrigger: Observable<Void>
    }
    struct Output {
        let uniformListData: PublishRelay<[PostData]>
    }
    func transfrom(input: Input) -> Output {
        let uniformListData = PublishRelay<[PostData]>()
        input.viewdidLoadTrigger
            .bind(with: self) { owner, value in
                NetworkManager.shared.fetchPost(productID: "premierLeague") { result in
                    switch result {
                    case .success(let fetchPost):
                        print(fetchPost)
                        uniformListData.accept(fetchPost.data)
                        NetworkManager.shared.callRequest(router: <#T##Router#>, completionHandler: <#T##(Result<Decodable, any Error>) -> Void#>)
                    case .failure(let error):
                        // 에러를 처리합니다.
                        print("Error fetching post: \(error)")
                    }
                }
            }
            .disposed(by: disposeBag)
        return Output(uniformListData: uniformListData)
    }
    
    
}
