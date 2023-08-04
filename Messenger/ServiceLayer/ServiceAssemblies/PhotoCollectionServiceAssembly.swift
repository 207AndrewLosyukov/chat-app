//
//  PhotoCollectionServiceAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 11.05.2023.
//

import Foundation

final class PhotoCollectionServiceAssembly {

    let themeService: GetThemeServiceProtocol
    let imageLoaderService: ImageLoaderServiceProtocol

    init(themeService: GetThemeServiceProtocol,
         imageLoaderService: ImageLoaderServiceProtocol
    ) {
        self.themeService = themeService
        self.imageLoaderService = imageLoaderService
    }
}
