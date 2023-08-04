//
//  EditProfileViewOutput.swift
//  Messenger
//
//  Created by Андрей Лосюков on 04.05.2023.
//

import UIKit

protocol EditProfileViewOutput: LoadThemeProtocol {

    var imageLoaderService: ImageLoaderServiceProtocol? {
        get
    }

    func loadProfileImage()

    func loadNameTextView()

    func loadBioTextView()

    func setImage(data: Data?)

    func saveProfile(with model: ProfileModel)

    func changeState()

    func openPickerIfPossible(for sourceType: UIImagePickerController.SourceType)
}
