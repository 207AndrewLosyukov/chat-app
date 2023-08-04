//
//  ConversationViewOutput.swift
//  Messenger
//
//  Created by Андрей Лосюков on 19.04.2023.
//

import Foundation

protocol ConversationViewOutput: LoadThemeProtocol, AnyObject {

    func loadMessages()

    func sendTapped(text: String?)

    func setupCache()

    func loadImage(with imageURL: String?)

    func loadMessageImage(with imageURL: String?, completion: @escaping ((Data) -> Void))

    func handlingSSE()
}
