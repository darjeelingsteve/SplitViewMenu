//
//  SceneDelegate.swift
//  SplitViewMenu
//
//  Created by Stephen Anthony on 14/01/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = MainSceneRootViewController()
        window?.makeKeyAndVisible()
    }
}
