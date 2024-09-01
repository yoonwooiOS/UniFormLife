//
//  SceneDelegate.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/14/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
//        UserDefaultsManeger.shared.token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2YmRkZDJlMzU4Y2MyODIzOGQxN2NlMSIsImlhdCI6MTcyNDY4MDg4NywiZXhwIjoxNzI0NjgxMTg3LCJpc3MiOiJzZXNhY18zIn0.jjSsMw0eQOnwUUJTvbFO367SGi48FJ0sepfUNdPP7xM"
//        UserDefaultsManeger.shared.refreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2YmRkZDJlMzU4Y2MyODIzOGQxN2NlMSIsImlhdCI6MTcyNDY4MDg4NywiZXhwIjoxNzI0NzY3Mjg3LCJpc3MiOiJzZXNhY18zIn0.H2XPZZPr8w6goJkKoUJBiLe1SPieiPYRfYgnI-_Q_r4"
//        let vc = (rootViewController: HomeTabBarController())
        let vc = HomeTabBarController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
    }
}
