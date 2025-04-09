//
//  SceneDelegate.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Functions

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession,
               options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let window: UIWindow = .init(windowScene: windowScene)

        window.rootViewController = LaunchViewController()
        window.makeKeyAndVisible()

        self.window = window
    }

    func sceneDidEnterBackground(_: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
