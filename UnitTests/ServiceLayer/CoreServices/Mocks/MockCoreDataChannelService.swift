//
//  MockCoreDataChannelService.swift
//  UnitTests
//
//  Created by Андрей Лосюков on 11.05.2023.
//

import Foundation
@testable import Messenger
import CoreData

final class MockCoreDataChannelService: CoreDataChannelServiceProtocol {

    var invokedFetchChannels = false
    var invokedFetchChannelsCount = 0
    var stubbedFetchChannelsResult: [DBChannel] = []

    func fetchChannels() -> [DBChannel] {
        invokedFetchChannels = true
        invokedFetchChannelsCount += 1
        return stubbedFetchChannelsResult
    }

    var invokedSave = false
    var invokedSaveCount = 0
    var stubbedSaveBlockResult: (NSManagedObjectContext, Void)?

    func save(block: @escaping (NSManagedObjectContext) throws -> Void) {
        invokedSave = true
        invokedSaveCount += 1
        if let result = stubbedSaveBlockResult {
            try? block(result.0)
        }
    }

    var invokedDeleteChannelsModels = false
    var invokedDeleteChannelsModelsCount = 0

    func deleteChannelsModels() {
        invokedDeleteChannelsModels = true
        invokedDeleteChannelsModelsCount += 1
    }

    var invokedDeleteChannelModel = false
    var invokedDeleteChannelModelCount = 0
    var invokedDeleteChannelModelChannelID: String?

    func deleteChannelModel(with channelID: String) {
        invokedDeleteChannelModel = true
        invokedDeleteChannelModelCount += 1
        invokedDeleteChannelModelChannelID = channelID
    }
}
