//
//  PaymentViewModel.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios
import WebKit

final class PaymentViewModel: ViewModelType {
   
    let disposedBag = DisposeBag()
    struct Input {
        let viewDidLoadTrigger: Observable<PostData>
        let webView: WKWebView
    }
    struct Output {
          let paymentResult: Observable<PaymentValidation>
          let error: Observable<Error>
      }
      func transform(input: Input) -> Output {
          let paymentResult = PublishSubject<PaymentValidation>()
          let error = PublishSubject<Error>()
          
          input.viewDidLoadTrigger
              .flatMapLatest { postData -> Observable<PaymentValidation> in
                  let payment = IamportPayment(
                      pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                      merchant_uid: "ios_\(APIKey.key)_\(Int(Date().timeIntervalSince1970))",
                      amount: "1").then {
                          $0.pay_method = PayMethod.card.rawValue
                          $0.name = postData.title
                          $0.buyer_name = postData.creator.user_id
                          $0.app_scheme = "sesac"
                      }
                  
                  return Single<String>.create { single in
                      Iamport.shared.paymentWebView(webViewMode: input.webView, userCode: APIKey.userCode, payment: payment) { iamportResponse in
                          if let imp_uid = iamportResponse?.imp_uid {
                              single(.success(imp_uid))
                          } else {
                              single(.failure(NSError(domain: "Payment Error", code: -1, userInfo: nil)))
                          }
                      }
                      return Disposables.create()
                  }
                  .asObservable()
                  .flatMapLatest { imp_uid -> Observable<PaymentValidation> in
                      NetworkManager.shared.callRequest(
                          router: .paymentValidation(validateData: PaymentValidateQuery(imp_uid: imp_uid, post_id: postData.post_id)),
                          type: PaymentValidation.self
                      )
                      .asObservable()
                      .flatMap { result -> Observable<PaymentValidation> in
                          switch result {
                          case .success(let validation):
                              return .just(validation)
                          case .failure(let err):
                              return .error(err)
                          }
                      }
                  }
              }
              .observe(on: MainScheduler.instance)
              .subscribe(
                  onNext: { result in
                      paymentResult.onNext(result)
                  },
                  onError: { err in
                      error.onNext(err)
                  }
              )
              .disposed(by: disposedBag)
          
          return Output(paymentResult: paymentResult.asObservable(), error: error.asObservable())
      }
  }
