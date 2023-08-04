//
//  ConversationListViewInput.swift
//  Messenger
//
//  Created by Андрей Лосюков on 18.04.2023.
//

import Foundation

protocol ConversationListViewInput: ViewSetupThemeProtocol, AnyObject {

    func showErrorAlert(title: String, message: String)

    func setLoading(enabled: Bool)

    func showAddChannelAlert()

    func showData(data: [ChatItem])
}
