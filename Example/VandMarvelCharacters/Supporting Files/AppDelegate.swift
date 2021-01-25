//
//  AppDelegate.swift
//  VandMarvelCharacters
//
//  Created by Vandcarlos on 01/19/2021.
//  Copyright (c) 2021 Vandcarlos. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private static let rootViewController = UINavigationController(rootViewController: MainViewController())

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        setupWindow()

        VandMarvelConfig.run()

        return true
    }

    private func setupWindow() {
        window?.rootViewController = AppDelegate.rootViewController
        window?.makeKeyAndVisible()
    }

}
