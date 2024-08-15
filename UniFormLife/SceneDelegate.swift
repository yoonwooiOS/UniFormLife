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
        
        let vc = UINavigationController(rootViewController: SignInViewController()) 
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

