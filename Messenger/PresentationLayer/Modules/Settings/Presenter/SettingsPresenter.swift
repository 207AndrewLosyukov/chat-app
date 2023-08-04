//
//  SettingsPresenter.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import Foundation

final class SettingsPresenter {

    private let setThemeService: SetThemeServiceProtocol?

    private let getThemeService: GetThemeServiceProtocol?

    private var theme: Theme?

    weak var viewInput: SettingsViewInput?

    init(serviceAssembly: SettingsServiceAssembly) {
        self.setThemeService = serviceAssembly.setThemeService
        self.getThemeService = serviceAssembly.getThemeService
    }
}

extension SettingsPresenter: SettingsViewOutput {
    func loadTheme() {
        self.theme = getThemeService?.getTheme()
        viewInput?.setupTheme(theme: theme ?? .day)
    }

    func didChangeTheme(theme: Theme) {
        self.theme = theme
        viewInput?.setupTheme(theme: theme)
        setThemeService?.setTheme(rawValue: theme.rawValue)
    }
}
