//
//  MockNetworkService.swift
//  UnitTests
//
//  Created by Андрей Лосюков on 10.05.2023.
//

import Foundation
@testable import Messenger
import CoreData

final class MockCoreDataMessageService: CoreDataMessageServiceProtocol {

    var invokedFetchMessages = false
    var invokedFetchMessagesCount = 0
    var invokedChannelID: String?
    var stubbedFetchMessagesResult: [DBMessage] = []

    func fetchMessages(for channelID: String) -> [DBMessage] {
        invokedFetchMessages = true
        invokedFetchMessagesCount += 1
        invokedChannelID = channelID
        return stubbedFetchMessagesResult
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
}
