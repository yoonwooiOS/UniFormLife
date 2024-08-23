//
//  HomeTabBarController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/16/24.
//

import UIKit

final class HomeTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let apearance = UITabBarAppearance()
        apearance.configureWithOpaqueBackground()
        tabBar.tintColor = Color.black
        tabBar.standardAppearance = apearance
        tabBar.scrollEdgeAppearance = apearance
        tabBar.unselectedItemTintColor = Color.gray
        
        let uniformListVC = UniformListViewController()
        let uniformList = UINavigationController(rootViewController: uniformListVC)
        uniformList.tabBarItem = UITabBarItem(title: "", image: Image.TabBar.uniformList, tag: 0)
        
        let feedVC = UniformStyleFeedViewController()
//        let feed = UINavigationController(rootViewController: feedVC)
//        feedVC.tabBarItem = UITabBarItem(title: "", image: Image.TabBar.feed, tag: 1)
       
        let addPostVC = AddPostViewController()
        let addPost = UINavigationController(rootViewController: addPostVC)
        addPost.tabBarItem = UITabBarItem(title: "", image: Image.TabBar.addPost, tag: 2)
        
        let profileVC = ProfileViewController()
        let profile = UINavigationController(rootViewController: profileVC)
        profile.tabBarItem = UITabBarItem(title: "", image: Image.TabBar.profile, tag: 3)
        
        setViewControllers([uniformList, addPost, profile], animated: true)
    }
}
