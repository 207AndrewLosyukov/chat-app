//
//  DBMessageModel.swift
//  Messenger
//
//  Created by Андрей Лосюков on 10.04.2023.
//

import Foundation

struct DBMessageModel: Hashable, Codable {

    let uuid: UUID
    let userID: String
    let text: String
    let date: Date
    let channelID: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    static func == (lhs: DBMessageModel, rhs: DBMessageModel) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
