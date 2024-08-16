//
//  UIViewController+Extension.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/14/24.
//

import UIKit

enum mode {
    case present
    case push
}

extension UIViewController {
    func goToOtehrVCwithCompletionHandler<T: UIViewController>(vc: T, mode: mode, completionHandler: @escaping (T) -> Void ) {
        let vc = vc
        switch mode {
        case .present:
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true) { [weak self] in
                guard self != nil else { return }
                completionHandler(vc)
            }
        case .push:
            navigationController?.pushViewController(vc, animated: true)
        }
        completionHandler(vc)
    }
    func goToOtehrVC(vc: UIViewController, mode: mode) {
        let vc = vc
        switch mode {
        case .present:
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .flipHorizontal
            present(vc, animated: true)
        case .push:
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func goToRootView(rootView: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let navigationController = UINavigationController(rootViewController: rootView)
        sceneDelegate?.window?.rootViewController = navigationController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    func showBasicAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "확인", style: .default))
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
