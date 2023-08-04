//
//  SettingsViewOutput.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import Foundation

protocol SettingsViewOutput {

    func didChangeTheme(theme: Theme)
    func loadTheme()
}
