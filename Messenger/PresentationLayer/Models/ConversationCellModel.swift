//
//  ConversationCellModel.swift
//  Messenger
//
//  Created by Андрей Лосюков on 05.03.2023.
//

import Foundation

struct ConversationCellModel: Hashable {

    let name: String
    let message: String?
    let date: Date?
    let isOnline: Bool
    let hasUnreadMessages: Bool
    let theme: Theme
}
