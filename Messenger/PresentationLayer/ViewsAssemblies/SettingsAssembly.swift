//
//  SettingsAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import UIKit

final class SettingsAssembly {

    private let serviceAssembly: SettingsServiceAssembly

    init(settingsServiceAssembly: SettingsServiceAssembly) {
        self.serviceAssembly = settingsServiceAssembly
    }

    func makeSettingsModule() -> UIViewController {

        let presenter = SettingsPresenter(serviceAssembly: serviceAssembly)
        let viewController = SettingsViewController(output: presenter)
        presenter.viewInput = viewController

        return viewController
    }
}
