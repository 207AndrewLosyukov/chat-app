//
//  ProfileViewOutput.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import UIKit

protocol ProfileViewOutput: LoadThemeProtocol {

    var imageLoaderService: ImageLoaderServiceProtocol {
        get
    }

    func didTapEditProfile()

    func loadNameLabel()

    func loadDescriptionLabel()

    func loadProfileImage()

    func setImage(data: Data?)

    func saveProfile(with model: ProfileModel)

    func openPickerIfPossible(for sourceType: UIImagePickerController.SourceType)
}
