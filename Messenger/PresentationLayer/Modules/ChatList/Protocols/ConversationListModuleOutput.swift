//
//  ConversationListModuleOutput.swift
//  Messenger
//
//  Created by Андрей Лосюков on 19.04.2023.
//

import Foundation

protocol ConversationListModuleOutput: AnyObject {

    func moduleWantsToOpenConversation(with channel: DBChannelModel)
}
