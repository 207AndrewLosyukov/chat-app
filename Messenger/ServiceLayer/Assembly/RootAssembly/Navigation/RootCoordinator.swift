//
//  RootCoordinator.swift
//  Messenger
//
//  Created by Андрей Лосюков on 19.04.2023.
//

import UIKit

final class RootCoordinator {

    private weak var window: UIWindow?

    private let rootAssembly: RootAssembly
    private let rootViewAssembly: RootViewAssembly

    init(rootAssembly: RootAssembly) {
        self.rootAssembly = rootAssembly
        self.rootViewAssembly = RootViewAssembly(rootAssembly: rootAssembly)
    }

    func start(in window: UIWindow) {
        window.rootViewController = rootViewAssembly.makeRootTabBar()
        window.makeKeyAndVisible()
        self.window = window
    }
}
