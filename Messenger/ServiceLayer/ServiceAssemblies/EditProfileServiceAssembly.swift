//
//  EditProfileServiceAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 04.05.2023.
//

import Foundation

final class EditProfileServiceAssembly {

    let userProfileService: UserProfileServiceProtocol
    let themeService: GetThemeServiceProtocol
    let imageLoaderService: ImageLoaderServiceProtocol

    init(userProfileService: UserProfileServiceProtocol,
         themeService: GetThemeServiceProtocol,
         imageLoaderService: ImageLoaderServiceProtocol
    ) {
        self.userProfileService = userProfileService
        self.themeService = themeService
        self.imageLoaderService = imageLoaderService
    }
}
