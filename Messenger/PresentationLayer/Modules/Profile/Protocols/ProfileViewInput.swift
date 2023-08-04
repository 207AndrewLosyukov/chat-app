//
//  ProfileViewInput.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import Foundation
import UIKit

protocol ProfileViewInput: ViewSetupThemeProtocol, AnyObject {

    func setNameLabel(text: String)

    func setDescriptionLabel(text: String)

    func setProfileImage(with data: Data?)

    func setImageFromPickerController(data: Data)

    func showCameraWasDeniedAlert(title: String)

    func showPickerConroller(for sourceType: UIImagePickerController.SourceType)
}
