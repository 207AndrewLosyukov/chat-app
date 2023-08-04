//
//  SettingsServiceAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import Foundation

final class SettingsServiceAssembly {

    let setThemeService: SetThemeServiceProtocol?
    let getThemeService: GetThemeServiceProtocol?

    init(setThemeService: SetThemeServiceProtocol,
         getThemeService: GetThemeServiceProtocol) {

        self.setThemeService = setThemeService
        self.getThemeService = getThemeService
    }
}
