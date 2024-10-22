//
//  BaseViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/14/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpHierarchy()
        setUpLayout()
        setUpView()
        setUpTableView()
        setUpNavigationItems()
        setUpNavigationTitle()
        bind()
        hideKeyboardWhenTappedAround()
    }
    func setUpHierarchy() { }
    func setUpLayout() { }
    func setUpView() { }
    func setUpTableView() { }
    func setUpButton() { }
    func setUpNavigationTitle() { }
    func bind() { }
    func setUpNavigationItems() {
        navigationItem.backBarButtonItem?.tintColor = .black
        let blackBackButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        blackBackButton.tintColor = .black
        navigationItem.backBarButtonItem = blackBackButton
    }
}


