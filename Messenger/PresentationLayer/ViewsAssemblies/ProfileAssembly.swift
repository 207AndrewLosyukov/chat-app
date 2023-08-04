//
//  ProfileAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import UIKit

final class ProfileAssembly {

    private let serviceAssembly: ProfileServiceAssembly

    init(profileServiceAssembly: ProfileServiceAssembly) {
        self.serviceAssembly = profileServiceAssembly
    }

    func makeProfileModule(moduleOutput: ProfileModuleOutput,
                           photoCollectionModuleOutput: ModuleAvailableToOpenPhotoCollection)
    -> UIViewController {

        let presenter = ProfilePresenter(serviceAssembly: serviceAssembly, moduleOutput: moduleOutput)
        let viewController = ProfileViewController(output: presenter)
        viewController.photoCollectionModuleOutput = photoCollectionModuleOutput
        presenter.viewInput = viewController

        return viewController
    }
}
