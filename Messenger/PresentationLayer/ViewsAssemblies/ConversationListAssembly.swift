//
//  ConversationListAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 19.04.2023.
//

import UIKit

final class ConversationListAssembly {

    private let serviceAssembly: ConversationListServiceAssembly

    init(conversationListServiceAssembly: ConversationListServiceAssembly) {
        self.serviceAssembly = conversationListServiceAssembly
    }

    func makeConversationListModule(
        moduleOutput: ConversationListModuleOutput) -> UIViewController {

        let presenter = ConversationListViewPresenter(
            serviceAssembly: serviceAssembly,
            moduleOutput: moduleOutput)
        let viewController = ConversationsListViewController(output: presenter)
        presenter.viewInput = viewController

        return viewController
    }
}
