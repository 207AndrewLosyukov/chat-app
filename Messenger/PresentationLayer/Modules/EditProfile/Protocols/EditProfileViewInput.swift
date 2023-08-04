//
//  EditProfileViewInput.swift
//  Messenger
//
//  Created by Андрей Лосюков on 04.05.2023.
//

import Foundation
import UIKit

protocol EditProfileViewInput: ViewSetupThemeProtocol, AnyObject {

    func setNameTextView(text: String)

    func setProfileImage(with data: Data?)

    func setBioTextView(text: String)

    func setState(state: EditProfileControllerState)

    func setImageFromPickerController(data: Data)

    func showCameraWasDeniedAlert(title: String)

    func showPickerConroller(for sourceType: UIImagePickerController.SourceType)
}
