//
//  HomeTabBarController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/16/24.
//

import UIKit

final class HomeTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.tintColor = Color.black
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.unselectedItemTintColor = Color.gray
        
        let uniformListVC = UniformListViewController()
        let uniformList = UINavigationController(rootViewController: uniformListVC)
        uniformList.tabBarItem = UITabBarItem(title: "", image: Image.TabBar.uniformList, tag: 0)
        
        let feedVC = UniformStyleFeedViewController()
        let feed = UINavigationController(rootViewController: feedVC)
        feed.tabBarItem = UITabBarItem(title: "", image: Image.TabBar.feed, tag: 1)

        let addPostVC = AddPostViewController()
        let addPost = UINavigationController(rootViewController: addPostVC)
        addPost.tabBarItem = UITabBarItem(title: "", image: Image.TabBar.addPost, tag: 2)
        
        let profileVC = ProfileViewController()
        let profile = UINavigationController(rootViewController: profileVC)
        profile.tabBarItem = UITabBarItem(title: "", image: Image.TabBar.profile, tag: 3)
        
        delegate = self
        setViewControllers([uniformList, feed, addPost, profile], animated: true)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            showPostOptions()
            return false
        }
        return true
    }

    private func showPostOptions() {
        let alertController = UIAlertController(title: "게시물 작성", message: "어떤 유형의 게시물을 작성하시겠습니까?", preferredStyle: .actionSheet)

        let usedProductAction = UIAlertAction(title: "중고제품 등록하기", style: .default) { [weak self] _ in
            self?.presentUsedProductVC()
        }

        let feedAction = UIAlertAction(title: "피드 등록하기", style: .default) { [weak self] _ in
            self?.presentFeedVC()
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(usedProductAction)
        alertController.addAction(feedAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    private func presentUsedProductVC() {
        let usedProductVC = AddPostViewController() // 이 클래스는 별도로 만들어야 합니다
        let nav = UINavigationController(rootViewController: usedProductVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

    private func presentFeedVC() {
        let feedVC = AddFeedViewController() // 이 클래스는 별도로 만들어야 합니다
        let nav = UINavigationController(rootViewController: feedVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
