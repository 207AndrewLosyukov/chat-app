//
//  PhotoCollectionAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 11.05.2023.
//

import UIKit

final class PhotoCollectionAssembly {

    private let serviceAssembly: PhotoCollectionServiceAssembly

    init(photoCollectionServiceAssembly: PhotoCollectionServiceAssembly) {
        self.serviceAssembly = photoCollectionServiceAssembly
    }

    func makePhotoCollectionModule(delegate: PhotoCollectionViewControllerDelegate) -> UIViewController {
        let presenter = PhotoCollectionPresenter(serviceAssembly: serviceAssembly)
        let viewController = PhotoCollectionViewController(output: presenter)
        presenter.viewInput = viewController
        presenter.delegate = delegate
        return viewController
    }
}
