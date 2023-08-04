//
//  ProfileUITest.swift
//  ProfileUITests
//
//  Created by Андрей Лосюков on 09.05.2023.
//

import XCTest

final class ProfileUITest: XCTestCase {

    func testProfileModule() {
        let app = XCUIApplication()
        app.launch()

        app.tabBars["tabBar"].buttons["profileButton"].tap()

        let profileIconView = app.images["profileIconView"]

        let userName = app.staticTexts["nameLabel"]

        let addPhotoButton = app.buttons["addPhotoButton"]

        XCTAssert(profileIconView.waitForExistence(timeout: 2))

        XCTAssert(userName.waitForExistence(timeout: 2))

        XCTAssert(addPhotoButton.waitForExistence(timeout: 2))
    }
}
