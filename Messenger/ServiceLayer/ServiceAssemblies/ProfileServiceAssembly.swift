//
//  ProfileServiceAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import Foundation

final class ProfileServiceAssembly {

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
