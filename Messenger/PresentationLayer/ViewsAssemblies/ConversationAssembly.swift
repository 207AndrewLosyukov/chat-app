//
//  ConversationAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import UIKit

final class ConversationAssembly {

    private let conversationServiceAssembly: ConversationServiceAssembly

    init(conversationServiceAssembly: ConversationServiceAssembly) {
        self.conversationServiceAssembly = conversationServiceAssembly
    }

    func makeConversationListModule(with model: DBChannelModel) -> UIViewController {

        let presenter = ConversationPresenter(serviceAssembly: conversationServiceAssembly, channelId: model.id)
        let viewController = ConversationViewController(output: presenter, model: model)
        presenter.viewInput = viewController

        return viewController
    }
}
