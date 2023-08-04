//
//  ThemeServiceProtocol.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import Foundation

protocol SetThemeServiceProtocol {

    func setTheme(rawValue: Int)
}

protocol GetThemeServiceProtocol {

    func getTheme() -> Theme
}

protocol LoadThemeProtocol {

    func loadTheme()
}

protocol ViewSetupThemeProtocol {

    func setupTheme(theme: Theme)
}
