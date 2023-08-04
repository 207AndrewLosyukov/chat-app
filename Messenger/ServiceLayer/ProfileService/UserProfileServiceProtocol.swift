//
//  UserProfileServiceProtocol.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import Foundation
import Combine

protocol UserProfileServiceProtocol {

    func save(userProfile: ProfileModel, completion: @escaping (() -> Void))

    func load() -> CurrentValueSubject<ProfileModel?, ProfileError>
}
