//
//  ModuleAvailableToOpenPhotoCollection.swift
//  Messenger
//
//  Created by Андрей Лосюков on 11.05.2023.
//

import UIKit

protocol ModuleAvailableToOpenPhotoCollection {

    func openPhotoCollection(from delegate: PhotoCollectionViewControllerDelegate,
                             completion: @escaping (UIViewController) -> Void)
}
