//
//  DBChannelModel.swift
//  Messenger
//
//  Created by Андрей Лосюков on 10.04.2023.
//

import Foundation

struct DBChannelModel: Hashable, Codable {

    let id: String
    let lastActivity: Date?
    let lastMessage: String?
    let logoURL: String?
    let name: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: DBChannelModel, rhs: DBChannelModel) -> Bool {
        lhs.id == rhs.id
    }
}
