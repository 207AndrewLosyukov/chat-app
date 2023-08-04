//
//  Theme.swift
//  Messenger
//
//  Created by Андрей Лосюков on 15.03.2023.
//

import UIKit

enum Theme: Int {
    case day = 0, night = 1
    var mainColors: ThemeModel {
        switch self {
        case .day:
            return ThemeModel(
                backgroundColor: .white,
                titleColor: .black,
                barStyle: .default,
                tintColor: .black,
                conversationListView: ConversationsListViewThemeModel(
                textColor: .black,
                secondaryTextColor: UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6),
                cellBackground: .white),
                conversationView: ConversationViewThemeModel(
                navBarColor: UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 0.1),
                receivedTextColor: .black,
                sendTextColor: .white,
                receivedBackground: UIColor(hexString: "#E9E9EB"),
                sendBackground: UIColor(hexString: "#448AF7")),
                profileView: ProfileViewThemeModel(textColor: .black,
                            backgroundColor: UIColor(hexString: "#F2F2F7")),
                themeView: ThemeViewThemeModel(
                secondaryBackgroundColor:
                        .secondarySystemBackground,
                textColor:
                        .black,
                rectangleViewColor:
                        .white))
        case .night:
            return ThemeModel(
                backgroundColor: .black,
                titleColor: .white,
                barStyle: .black,
                tintColor: .white,
                conversationListView: ConversationsListViewThemeModel(
                textColor: .white,
                secondaryTextColor: .systemGray2,
                cellBackground: .black),
                conversationView: ConversationViewThemeModel(
                navBarColor: .darkGray,
                receivedTextColor: .white,
                sendTextColor: .white,
                receivedBackground: .darkGray,
                sendBackground: UIColor(hexString: "#448AF7")),
                profileView: ProfileViewThemeModel(textColor: .black,
                                                   backgroundColor: .black),
                themeView: ThemeViewThemeModel(
                secondaryBackgroundColor: .black,
                textColor: .white,
                rectangleViewColor: .darkGray))
        }
    }
}
