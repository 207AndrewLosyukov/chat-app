//
//  ThemeService.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import Foundation

final class ThemeService: SetThemeServiceProtocol, GetThemeServiceProtocol {

    private var theme: Theme?
    private var isNeedToReload = false

    func setTheme(rawValue: Int) {
        self.theme = Theme(rawValue: rawValue)
        UserDefaults.standard.setValue(rawValue, forKey: "theme")
        isNeedToReload = true
    }

    func getTheme() -> Theme {

        if let theme = theme,
        !isNeedToReload {
            return theme
        } else {
            isNeedToReload = false
            if let themeRawValue = UserDefaults.standard.string(forKey: "theme"),
               let savedTheme = Theme(rawValue: Int(themeRawValue) ?? 0) {
                self.theme = savedTheme
                return savedTheme
            }
        }
        return .day
    }
}
