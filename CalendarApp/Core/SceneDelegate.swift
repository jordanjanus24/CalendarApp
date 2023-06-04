//
//  SceneDelegate.swift
//  CalendarApp
//
//  Created by Janus Jordan on 5/31/23.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var coordinator: AppCoordinator?
    var window: UIWindow?
    private let disposeBag = DisposeBag()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = (scene as? UIWindowScene) {
            window = UIWindow(windowScene: windowScene)
            coordinator = AppCoordinator(window: window ?? UIWindow())
            coordinator?.start()
                .subscribe()
                .disposed(by: disposeBag)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

