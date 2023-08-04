//
//  AppDelegate.swift
//  Messenger
//
//  Created by Андрей Лосюков on 21.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: RootCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let serviceFactory = ServiceFactory()

        coordinator = RootCoordinator(
            rootAssembly: RootAssembly(
                serviceFactory: serviceFactory
            )
        )

        coordinator?.start(in: window)

        return true
    }
}
