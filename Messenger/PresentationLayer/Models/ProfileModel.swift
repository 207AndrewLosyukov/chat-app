//
//  ProfileModel.swift
//  Messenger
//
//  Created by Андрей Лосюков on 05.03.2023.
//

import Foundation

class ProfileModel: Codable {

    let name: String?
    let description: String?
    let imageData: Data?

    init(name: String?, description: String?, imageData: Data?) {
        self.name = name
        self.description = description
        self.imageData = imageData
    }
}
