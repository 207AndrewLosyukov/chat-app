//
//  UserProfileManager.swift
//  Messenger
//
//  Created by Андрей Лосюков on 29.03.2023.
//

import Combine
import UIKit

class ProfileError: Error {}

class UserProfileService: UserProfileServiceProtocol {

    private let subject = CurrentValueSubject<ProfileModel?, ProfileError>(nil)

    private let profileURL = FileManager.default.urls(for: .documentDirectory,
    in: .userDomainMask).first?.appendingPathComponent("profile.json") ?? FileManager.default.temporaryDirectory

    private let jsonDecoder = JSONDecoder()

    private let jsonEncoder = JSONEncoder()

    private let queue = DispatchQueue.global(qos: .background)

    func save(userProfile: ProfileModel, completion: @escaping (() -> Void)) {
        subject.send(userProfile)
        queue.async {
            do {
                let profileData = try self.jsonEncoder.encode(userProfile)
                try profileData.write(to: self.profileURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func load() -> CurrentValueSubject<ProfileModel?, ProfileError> {
        queue.async {
            let profileModel = try? self.jsonDecoder.decode(ProfileModel.self,
            from: (try? Data(contentsOf: self.profileURL)) ?? Data())
            self.subject.send(profileModel)
        }
        return subject
    }
}
