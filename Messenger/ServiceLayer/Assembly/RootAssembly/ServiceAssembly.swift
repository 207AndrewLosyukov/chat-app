//
//  ServiceAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 19.04.2023.
//

import Foundation
import TFSChatTransport

final class ServiceAssembly {

    private let host = "167.235.86.234"
    private let port = 8080
    private let apiKey = "35805955-f078e993bdb5fbd72606dc818"

    private let themeService = ThemeService()
    private let coreDataService = CoreDataService()

    lazy var chatService: ChatServiceProtocol = {
        ChatService(host: host, port: port)
    }()

    func getSSEService() -> SSEServiceProtocol {
        SSEService(host: host, port: port)
    }

    lazy var imageLoaderService: ImageLoaderServiceProtocol = {
        ImageLoaderService(networkService: NetworkService(), apiKey: apiKey)
    }()

    lazy var channelDataSourceService: ChannelDataSourceProtocol = {
        ChannelDataSourceService(coreDataChannelService: coreDataService)
    }()

    lazy var messageDataSourceService: MessageDataSourceProtocol = {
        MessageDataSourceService(coreDataMessageService: coreDataService)
    }()

    lazy var userProfileService: UserProfileServiceProtocol = {
        UserProfileService()
    }()

    func getThemeService() -> GetThemeServiceProtocol {
        themeService
    }

    func setThemeService() -> SetThemeServiceProtocol {
        themeService
    }
}
