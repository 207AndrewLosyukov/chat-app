//
//  ConversationServiceAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import Foundation
import TFSChatTransport

final class ConversationServiceAssembly {

    let messageDataSourceService: MessageDataSourceProtocol?
    let imageLoaderService: ImageLoaderServiceProtocol?
    let chatService: ChatServiceProtocol?
    let themeService: GetThemeServiceProtocol?
    let sseService: SSEServiceProtocol?

    init(messageDataSourceService: MessageDataSourceProtocol?,
         imageLoaderService: ImageLoaderServiceProtocol?,
         chatService: ChatServiceProtocol?,
         themeService: GetThemeServiceProtocol?,
         sseService: SSEServiceProtocol?
    ) {
        self.messageDataSourceService = messageDataSourceService
        self.imageLoaderService = imageLoaderService
        self.chatService = chatService
        self.themeService = themeService
        self.sseService = sseService
    }
}
