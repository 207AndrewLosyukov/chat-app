//
//  EditProfileAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 04.05.2023.
//

import UIKit

final class EditProfileAssembly {

    private let serviceAssembly: EditProfileServiceAssembly

    init(editProfileServiceAssembly: EditProfileServiceAssembly) {
        self.serviceAssembly = editProfileServiceAssembly
    }

    func makeEditProfileModule(photoCollectionModuleOutput: ModuleAvailableToOpenPhotoCollection)
    -> UIViewController {

        let presenter = EditProfilePresenter(serviceAssembly: serviceAssembly)
        let viewController = EditProfileViewController(output: presenter)
        viewController.photoCollectionModuleOutput = photoCollectionModuleOutput
        presenter.viewInput = viewController
        return viewController
    }
}
