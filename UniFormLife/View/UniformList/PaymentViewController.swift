//
//  PaymentViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/31/24.
//

import UIKit
import WebKit
import iamport_ios
import SnapKit
import RxSwift
import Then


final class PaymentViewController: BaseViewController {
    var postData: PostData?
    private lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let viewModel = PaymentViewModel()
    let disposedBag = DisposeBag()
    
    override func bind() {
        guard let postData else { return }
        let input = PaymentViewModel.Input(viewDidLoadTrigger: Observable.just(postData), webView: wkWebView)
        let output = viewModel.transform(input: input)
        
        output.paymentResult
            .bind(with: self) { owner, value in
                print(value)
                owner.showBasicAlertWithCompletionHandler("결제가 완료되었습니다.") {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposedBag)
        output.error
            .bind(with: self) { owner, error in
                print(error)
                owner.showBasicAlertWithCompletionHandler("결제에 실패하셨습니다. 잠시후 다시 시도해주세요!") {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposedBag)
    }
    override func setUpHierarchy() {
        view.addSubview(wkWebView)
       
    }
    override func setUpLayout() {
        wkWebView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
