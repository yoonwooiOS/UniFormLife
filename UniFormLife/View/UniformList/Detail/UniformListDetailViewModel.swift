//
//  UniformListDetailViewModel.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UniformListDetailViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let likeButtonTapped: ControlEvent<Void>
    }
    struct Output {
        let isLiked: Observable<Bool>
    }
    
    func transfrom(input: Input) -> Output {
   
        let isLiked = BehaviorRelay<Bool>(value: false)
        
        input.likeButtonTapped
            .asObservable()
            .withLatestFrom(isLiked)
            .map { !$0 }
            .bind(to: isLiked)
            .disposed(by: disposeBag)
        
       
        input.likeButtonTapped
            .asObservable()
            .flatMapLatest { _ in
                NetworkManager.shared.callRequest(router: .likePost(postID: "66c967cf5056517017a46c0e", likeState: false), type: LikePost.self)
            }
            .bind(with: self, onNext: { owner, result in
                    switch result {
                    case .success(let likePost):
                        print("성공적으로 응답 받음:", likePost)
                    case .failure(let error):
                        print("서버 에러 발생:", error)
                    }
                })
                .disposed(by: disposeBag)
               let isLikedObservable = isLiked.asObservable()
               
               return Output(isLiked: isLikedObservable)
    }
}
