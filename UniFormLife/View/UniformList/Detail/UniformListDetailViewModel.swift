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
    
    func transform(input: Input) -> Output {
   
        let isLiked = BehaviorRelay<Bool>(value: false)
        
    
        input.likeButtonTapped
            .withLatestFrom(isLiked)
            .map { !$0 }
            .bind(to: isLiked)
            .disposed(by: disposeBag)
        
  
        input.likeButtonTapped
            .flatMapLatest { _ in
                NetworkManager.shared.callRequest(router: .likePost(postID: "66c967cf5056517017a46c0e", likeState: false), type: LikePost.self)
            }
            .bind(with: self, onNext: { owner, result in
                switch result {
                case .success(let likePost):
                    print("성공적으로 응답 받음:", likePost)
                case .failure(let error):
                    print("네트워크 요청 실패:", error)
                }
            })
            .disposed(by: disposeBag)
               // isLiked를 Observable로 변환하여 출력
               let isLikedObservable = isLiked.asObservable()
               
               return Output(isLiked: isLikedObservable)
    }
}
