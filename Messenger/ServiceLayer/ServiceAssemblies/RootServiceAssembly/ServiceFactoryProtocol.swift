//
//  File.swift
//  Messenger
//
//  Created by Андрей Лосюков on 11.05.2023.
//

import Foundation

protocol ServiceFactoryProtocol {

    func makeConversationListServiceAssembly() -> ConversationListServiceAssembly

    func makeConversationServiceAssembly() -> ConversationServiceAssembly

    func makeProfileServiceAssembly() -> ProfileServiceAssembly

    func makeEditProfileServiceAssembly() -> EditProfileServiceAssembly

    func makeSettingsServiceAssembly() -> SettingsServiceAssembly

    func makePhotoCollectionServiceAssembly() -> PhotoCollectionServiceAssembly
}
