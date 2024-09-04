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
        let paymentButtonTapped: ControlEvent<Void>
        let postData: PostData?
    }
    struct Output {
        let isLiked: Observable<Bool>
        let fetchUserPost: Observable<[PostData]>
        let paymentButtonTapped: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
   
        let isLiked = BehaviorRelay<Bool>(value: false)
        let isLikedObservable = isLiked.asObservable()
        let fetchUserPostSubject = BehaviorSubject<[PostData]>(value: [])

        input.likeButtonTapped
            .withLatestFrom(isLiked)
            .map { !$0 }
            .bind(to: isLiked)
            .disposed(by: disposeBag)
        input.likeButtonTapped
            .flatMapLatest { _ in
                NetworkManager.shared.callRequest(router: .likePost(postID: "66c967cf5056517017a46c0e", query: LikeQuery(like_status: false)), type: LikePost.self)
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
       
        NetworkService.shared.fetchUserPost(userId: input.postData?.creator.user_id ?? "")
            .subscribe(onSuccess: { result in
                switch result {
                case .success(let fetchPost):
                    fetchUserPostSubject.onNext(fetchPost.data)
                case .failure(let error):
                    print("FetchUserPost 실패: \(error)")
                }
            }, onFailure: { error in
                print("네트워크 요청 실패: \(error)")
            })
            .disposed(by: disposeBag)

        let fetchUserPostData = fetchUserPostSubject.asObservable()
        
        return Output(isLiked: isLikedObservable, fetchUserPost: fetchUserPostData, paymentButtonTapped: input.paymentButtonTapped)
    }
}
