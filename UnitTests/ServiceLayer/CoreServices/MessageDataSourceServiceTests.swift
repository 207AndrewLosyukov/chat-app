//
//  MessageDataSourceServiceTests.swift
//  MessageDataSourceServiceTests
//
//  Created by Андрей Лосюков on 09.05.2023.
//

import XCTest
@testable import Messenger
import CoreData

final class MessageDataSourceServiceTests: XCTestCase {

    var mockCoreDataMessageService: MockCoreDataMessageService?
    var messagesService: MessageDataSourceService?

    override func setUp() {
        let mock = MockCoreDataMessageService()
        mockCoreDataMessageService = mock
        messagesService = MessageDataSourceService(coreDataMessageService: mock)
    }

    func testFetchMessages() throws {
        let channelId = UUID().uuidString

        _ = messagesService?.getMessages(for: channelId)

        XCTAssertTrue(mockCoreDataMessageService?.invokedFetchMessages ?? false)
        XCTAssertEqual(mockCoreDataMessageService?.invokedFetchMessagesCount, 1)
        XCTAssertEqual(channelId, mockCoreDataMessageService?.invokedChannelID)
    }

    func testSave() {
        _ = messagesService?.saveMessageModel(
            with: DBMessageModel(uuid: UUID(), userID: "", text: "", date: Date(), channelID: ""), in: ""
        )

        XCTAssertTrue(mockCoreDataMessageService?.invokedSave ?? false)
        XCTAssertEqual(mockCoreDataMessageService?.invokedSaveCount, 1)
    }
}
