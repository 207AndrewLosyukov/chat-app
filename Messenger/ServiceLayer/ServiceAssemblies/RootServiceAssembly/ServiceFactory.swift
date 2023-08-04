//
//  RootServiceAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 11.05.2023.
//

import Foundation

final class ServiceFactory: ServiceFactoryProtocol {

    private let serviceAssembly = ServiceAssembly()

    func makeConversationListServiceAssembly() -> ConversationListServiceAssembly {
        let conversationListServiceAssembly = ConversationListServiceAssembly(
            channelDataSourceService: serviceAssembly.channelDataSourceService,
            imageLoaderService: serviceAssembly.imageLoaderService,
            chatService: serviceAssembly.chatService,
            themeService: serviceAssembly.getThemeService(),
            sseService: serviceAssembly.getSSEService()
        )

        return conversationListServiceAssembly
    }

    func makeConversationServiceAssembly() -> ConversationServiceAssembly {
        let conversationServiceAssembly = ConversationServiceAssembly(
            messageDataSourceService: serviceAssembly.messageDataSourceService,
            imageLoaderService: serviceAssembly.imageLoaderService,
            chatService: serviceAssembly.chatService,
            themeService: serviceAssembly.getThemeService(),
            sseService: serviceAssembly.getSSEService())

        return conversationServiceAssembly
    }

    func makeProfileServiceAssembly() -> ProfileServiceAssembly {
        let profileServiceAssembly = ProfileServiceAssembly(userProfileService: serviceAssembly.userProfileService,
            themeService: serviceAssembly.getThemeService(),
            imageLoaderService: serviceAssembly.imageLoaderService)
        return profileServiceAssembly
    }

    func makeEditProfileServiceAssembly() -> EditProfileServiceAssembly {
        let editProfileServiceAssembly = EditProfileServiceAssembly(
            userProfileService: serviceAssembly.userProfileService,
            themeService: serviceAssembly.getThemeService(),
            imageLoaderService: serviceAssembly.imageLoaderService)
        return editProfileServiceAssembly
    }

    func makeSettingsServiceAssembly() -> SettingsServiceAssembly {
        let settingsServiceAssembly = SettingsServiceAssembly(
            setThemeService: serviceAssembly.setThemeService(),
            getThemeService: serviceAssembly.getThemeService()
        )
        return settingsServiceAssembly
    }

    func makePhotoCollectionServiceAssembly() -> PhotoCollectionServiceAssembly {
        let photoCollectionServiceAssembly = PhotoCollectionServiceAssembly(
            themeService: serviceAssembly.getThemeService(),
            imageLoaderService: serviceAssembly.imageLoaderService
        )
        return photoCollectionServiceAssembly
    }
}
