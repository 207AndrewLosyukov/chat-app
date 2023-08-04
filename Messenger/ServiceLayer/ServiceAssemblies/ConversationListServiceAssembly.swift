//
//  ConversationListServiceAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 19.04.2023.
//

import Foundation
import TFSChatTransport

final class ConversationListServiceAssembly {

    let channelDataSourceService: ChannelDataSourceProtocol?
    let imageLoaderService: ImageLoaderServiceProtocol?
    let chatService: ChatServiceProtocol?
    let themeService: GetThemeServiceProtocol?
    let sseService: SSEServiceProtocol?

    init(channelDataSourceService: ChannelDataSourceProtocol?,
         imageLoaderService: ImageLoaderServiceProtocol?,
         chatService: ChatServiceProtocol,
         themeService: GetThemeServiceProtocol,
         sseService: SSEServiceProtocol
    ) {
        self.channelDataSourceService = channelDataSourceService
        self.imageLoaderService = imageLoaderService
        self.chatService = chatService
        self.themeService = themeService
        self.sseService = sseService
    }
}
