//
//  ChannelDataSourceServiceTests.swift
//  UnitTests
//
//  Created by Андрей Лосюков on 11.05.2023.
//

import Foundation

import XCTest
@testable import Messenger

final class ChannelDataSourceServiceTests: XCTestCase {

    var mockCoreDataChannelService: MockCoreDataChannelService?
    var channelService: ChannelDataSourceService?

    override func setUp() {
        let mock = MockCoreDataChannelService()
        mockCoreDataChannelService = mock
        channelService = ChannelDataSourceService(coreDataChannelService: mock)
    }

    func testFetchChannels() {
        _ = channelService?.getChannelsModels()

        XCTAssertTrue(mockCoreDataChannelService?.invokedFetchChannels ?? false)
        XCTAssertEqual(mockCoreDataChannelService?.invokedFetchChannelsCount, 1)
    }

    func testSave() {
        _ = channelService?.saveChannelModel(
            with: DBChannelModel(id: "", lastActivity: nil, lastMessage: nil, logoURL: nil, name: "")
        )

        XCTAssertTrue(mockCoreDataChannelService?.invokedSave ?? false)
        XCTAssertEqual(mockCoreDataChannelService?.invokedSaveCount, 1)
    }

    func testDeleteChannelsModels() {
        channelService?.deleteChannelsModels()

        XCTAssertTrue(mockCoreDataChannelService?.invokedDeleteChannelsModels ?? false)
        XCTAssertEqual(mockCoreDataChannelService?.invokedDeleteChannelsModelsCount, 1)
    }

    func testDeleteChannelModel() {
        let channelId = UUID().uuidString

        channelService?.deleteChannelModel(with: channelId)

        XCTAssertTrue(mockCoreDataChannelService?.invokedDeleteChannelModel ?? false)
        XCTAssertEqual(mockCoreDataChannelService?.invokedDeleteChannelModelCount, 1)
        XCTAssertEqual(channelId, mockCoreDataChannelService?.invokedDeleteChannelModelChannelID)
    }
}
