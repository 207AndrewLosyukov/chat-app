//
//  MakeNavigationProtocol.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import UIKit

protocol MakeNavigationProtocol {

    func makeConversationListNavigationController() -> UINavigationController

    func makeSettingsNavigationController() -> UINavigationController

    func makeProfileNavigationController() -> UINavigationController
}
