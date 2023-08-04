//
//  ConversationViewInput.swift
//  Messenger
//
//  Created by Андрей Лосюков on 19.04.2023.
//

import Foundation

protocol ConversationViewInput: ViewSetupThemeProtocol, AnyObject {

    func showErrorAlert(title: String, message: String)

    func showNilTextAlert(title: String, message: String)

    func showData(dataMessages: [[MessageItem]], sections: [MessageSection])

    func eraseText()

    func setSections(sections: [MessageSection])

    func setImage(data: Data)
}
