//
//  UIViewController+Extension.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/14/24.
//

import UIKit
import Kingfisher

enum mode {
    case present
    case push
}

extension UIViewController {
    func goToOtehrVCwithCompletionHandler<T: UIViewController>(vc: T, mode: mode,tabbarHidden: Bool? = nil, completionHandler: @escaping (T) -> Void ) {
        let vc = vc
        switch mode {
        case .present:
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true) { [weak self] in
                guard self != nil else { return }
                completionHandler(vc)
            }
        case .push:
            vc.hidesBottomBarWhenPushed = tabbarHidden ?? false
            navigationController?.pushViewController(vc, animated: true)
           
        }
        completionHandler(vc)
    }
    func goToOtehrVC(vc: UIViewController, mode: mode, tabbarHidden: Bool? = nil) {
        let vc = vc
        switch mode {
        case .present:
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .flipHorizontal
            present(vc, animated: true)
        case .push:
            vc.hidesBottomBarWhenPushed = tabbarHidden ?? false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToRootView(rootView: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = rootView
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    func showBasicAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "확인", style: .default))
          self.present(alert, animated: true)
    }
    func showBasicAlertWithCompletionHandler(_ title: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler()
        }
        alert.addAction(confirmAction)
        self.present(alert, animated: true)
    }
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
