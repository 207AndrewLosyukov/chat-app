//
//  EditProfileControllerPresenter.swift
//  Messenger
//
//  Created by Андрей Лосюков on 04.05.2023.
//

import Foundation
import Combine
import AVFoundation
import UIKit

final class EditProfilePresenter {

    private let userProfileService: UserProfileServiceProtocol?

    let imageLoaderService: ImageLoaderServiceProtocol?

    private var cancellables = Set<AnyCancellable>()

    private var theme: Theme?

    private let themeService: GetThemeServiceProtocol?

    weak var viewInput: EditProfileViewInput?

    private var state: EditProfileControllerState = .didEditTapped

    init(serviceAssembly: EditProfileServiceAssembly) {
        userProfileService = serviceAssembly.userProfileService
        themeService = serviceAssembly.themeService
        imageLoaderService = serviceAssembly.imageLoaderService
    }
}

extension EditProfilePresenter: EditProfileViewOutput {

    func changeState() {
        switch state {
        case .didEditTapped:
            state = .saving
        case .saving:
            state = .didEditTapped
        }
        viewInput?.setState(state: state)
    }

    func loadTheme() {
        self.theme = themeService?.getTheme()
        viewInput?.setupTheme(theme: theme ?? .day)
    }

    func loadProfileImage() {
        userProfileService?
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

    func loadNameTextView() {
        userProfileService?
            .load()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] in
                self?.viewInput?.setNameTextView(text: $0?.name ?? "Stephen Johnson")
            })
            .store(in: &cancellables)
    }

    func loadBioTextView() {
        userProfileService?
            .load()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] in
                self?.viewInput?.setBioTextView(text: $0?.description ?? "UX/UI designer, web designer Moscow, Russia")
            })
            .store(in: &cancellables)
    }

    func saveProfile(with model: ProfileModel) {
        userProfileService?.save(userProfile: model) { [weak self] in
            self?.changeState()
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
