//
//  RootAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 19.04.2023.
//

import Foundation

final class RootAssembly {

    let conversationListAssembly: ConversationListAssembly

    let conversationAssembly: ConversationAssembly

    let profileAssembly: ProfileAssembly

    let settingsAssembly: SettingsAssembly

    let editProfileAssembly: EditProfileAssembly

    let photoCollectionAssembly: PhotoCollectionAssembly

    init(serviceFactory: ServiceFactoryProtocol) {

        let conversationListServiceAssembly = serviceFactory.makeConversationListServiceAssembly()
        self.conversationListAssembly = ConversationListAssembly(
            conversationListServiceAssembly: conversationListServiceAssembly
        )

        let conversationServiceAssembly = serviceFactory.makeConversationServiceAssembly()
        self.conversationAssembly = ConversationAssembly(
            conversationServiceAssembly: conversationServiceAssembly
        )

        let profileServiceAssembly = serviceFactory.makeProfileServiceAssembly()
        self.profileAssembly = ProfileAssembly(
            profileServiceAssembly: profileServiceAssembly
        )

        let settingsServiceAssembly = serviceFactory.makeSettingsServiceAssembly()
        self.settingsAssembly = SettingsAssembly(
            settingsServiceAssembly: settingsServiceAssembly
        )

        let editProfileServiceAssembly = serviceFactory.makeEditProfileServiceAssembly()
        self.editProfileAssembly = EditProfileAssembly(
            editProfileServiceAssembly: editProfileServiceAssembly
        )

        let photoCollectionServiceAssembly = serviceFactory.makePhotoCollectionServiceAssembly()
        self.photoCollectionAssembly = PhotoCollectionAssembly(
            photoCollectionServiceAssembly: photoCollectionServiceAssembly
        )
    }
}
