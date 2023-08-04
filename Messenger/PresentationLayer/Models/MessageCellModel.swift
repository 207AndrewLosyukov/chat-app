//
//  MessageCellModel.swift
//  Messenger
//
//  Created by Андрей Лосюков on 08.03.2023.
//

import Foundation

struct MessageCellModel: Hashable {

    let text: String
    let date: Date
    let isIncoming: Bool
    let userId: String
    let theme: Theme
}
