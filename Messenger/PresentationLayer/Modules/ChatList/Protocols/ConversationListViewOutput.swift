//
//  ConversationListViewOutput.swift
//  Messenger
//
//  Created by Андрей Лосюков on 18.04.2023.
//

import Foundation

protocol ConversationListViewOutput: LoadThemeProtocol, AnyObject {

    func deleteChannel(by id: String)

    func refreshChannels()

    func setupCachedChannels()

    func resaveCoreData()

    func addChannel(name: String?, logoUrl: String?)

    func didTapChannel(at itemIndex: Int)

    func handleEvents()

    func loadImage(logoURL: String?, handler: @escaping ((Result<Data, Error>) -> Void))
}
