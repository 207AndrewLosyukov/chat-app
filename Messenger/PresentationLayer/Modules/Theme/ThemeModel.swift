//
//  ThemeModel.swift
//  Messenger
//
//  Created by Андрей Лосюков on 14.03.2023.
//

import UIKit

struct ThemeModel {
    let backgroundColor: UIColor
    let titleColor: UIColor
    let barStyle: UIBarStyle
    let tintColor: UIColor
    let conversationListView: ConversationsListViewThemeModel
    let conversationView: ConversationViewThemeModel
    let profileView: ProfileViewThemeModel
    let themeView: ThemeViewThemeModel
}

struct ConversationsListViewThemeModel {
    let textColor: UIColor
    let secondaryTextColor: UIColor
    let cellBackground: UIColor
}

struct ConversationViewThemeModel {
    let navBarColor: UIColor
    let receivedTextColor: UIColor
    let sendTextColor: UIColor
    let receivedBackground: UIColor
    let sendBackground: UIColor
}

struct ProfileViewThemeModel {
    let textColor: UIColor
    let backgroundColor: UIColor
}

struct ThemeViewThemeModel {
    let secondaryBackgroundColor: UIColor
    let textColor: UIColor
    let rectangleViewColor: UIColor
}
