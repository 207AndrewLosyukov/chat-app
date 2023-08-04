//
//  ProfilePresenter.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.04.2023.
//

import Foundation
import Combine
import AVFoundation
import UIKit

final class ProfilePresenter {

    let userProfileService: UserProfileServiceProtocol

    let imageLoaderService: ImageLoaderServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    private var theme: Theme?

    private var moduleOutput: ProfileModuleOutput

    let themeService: GetThemeServiceProtocol

    weak var viewInput: ProfileViewInput?

    init(serviceAssembly: ProfileServiceAssembly,
         moduleOutput: ProfileModuleOutput) {

        userProfileService = serviceAssembly.userProfileService
        themeService = serviceAssembly.themeService
        imageLoaderService = serviceAssembly.imageLoaderService
        self.moduleOutput = moduleOutput
    }
}

extension ProfilePresenter: ProfileViewOutput {

    func didTapEditProfile() {
        moduleOutput.moduleWantsToOpenEditProfile()
    }

    func loadTheme() {
        self.theme = themeService.getTheme()
        viewInput?.setupTheme(theme: theme ?? .day)
    }

    func loadNameLabel() {
        userProfileService
            .load()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] in
                self?.viewInput?.setNameLabel(text: $0?.name ?? "No name")
            })
            .store(in: &cancellables)
    }

    func loadDescriptionLabel() {
        userProfileService
            .load()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] in
                self?.viewInput?.setDescriptionLabel(text: $0?.description ?? "No bio specified")
            })
            .store(in: &cancellables)
    }

    func loadProfileImage() {
        userProfileService
            .load()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] in
                if let model = $0 {
                    self?.viewInput?.setProfileImage(with: model.imageData ??
                    Resources.Images.noNameImage?.pngData())
                }
            })
            .store(in: &cancellables)
    }

    func saveProfile(with model: ProfileModel) {
        userProfileService.save(userProfile: model) {
        }
    }

    func setImage(data: Data?) {
        if let data = data {
            viewInput?.setProfileImage(with: data)
        }
    }

    func openPickerIfPossible(for sourceType: UIImagePickerController.SourceType) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            viewInput?.showPickerConroller(for: sourceType)
        default:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] granted in
                guard let self else { return }
                DispatchQueue.main.async {
                    if granted {
                        self.viewInput?.showPickerConroller(for: sourceType)
                    } else {
                        self.viewInput?.showCameraWasDeniedAlert(title: "Camera was denied")
                    }
                }
            })
        }
    }
}
