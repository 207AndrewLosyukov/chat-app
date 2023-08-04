//
//  RootViewAssembly.swift
//  Messenger
//
//  Created by Андрей Лосюков on 11.05.2023.
//

import UIKit

enum Tabs: Int {
    case channels
    case settings
    case profile
}

final class RootViewAssembly {

    private let rootAssembly: RootAssembly

    private var conversationListNavigationController: UINavigationController?

    private var profileNavigationController: UINavigationController?
    init(rootAssembly: RootAssembly) {
        self.rootAssembly = rootAssembly
    }

    func makeRootTabBar() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.layer.borderColor = Resources.Colors.separator.cgColor
        tabBarController.tabBar.layer.borderWidth = 0.5

        tabBarController.tabBar.frame = CGRect(x: -0.5,
                                               y: 0,
                                               width: tabBarController.view.frame.width + 0.5,
                                               height: 84)

        tabBarController.tabBar.layer.masksToBounds = true
        tabBarController.overrideUserInterfaceStyle = .light
        tabBarController.setViewControllers([
            makeConversationListNavigationController(),
            makeSettingsNavigationController(),
            makeProfileNavigationController()
        ], animated: false)
        tabBarController.tabBar.accessibilityIdentifier = "tabBar"
        return tabBarController
    }
}

extension RootViewAssembly: ConversationListModuleOutput,
                            ProfileModuleOutput, ModuleAvailableToOpenPhotoCollection {

    func openPhotoCollection(from delegate: PhotoCollectionViewControllerDelegate,
                             completion: @escaping (UIViewController) -> Void) {
        let photoCollectionAssembly = rootAssembly.photoCollectionAssembly

        let photoCollectionViewController = photoCollectionAssembly.makePhotoCollectionModule(delegate: delegate)

        completion(photoCollectionViewController)
    }

    func moduleWantsToOpenConversation(with channel: DBChannelModel) {

        let conversationAssembly = rootAssembly.conversationAssembly

        let conversationViewController =
        conversationAssembly.makeConversationListModule(with: channel)

        conversationListNavigationController?.pushViewController(conversationViewController, animated: true)
    }

    func moduleWantsToOpenEditProfile() {
        let editProfileAssembly = rootAssembly.editProfileAssembly
        let editProfileViewController = editProfileAssembly.makeEditProfileModule(photoCollectionModuleOutput: self)
        profileNavigationController?.present(editProfileViewController, animated: true)
    }
}

extension RootViewAssembly: MakeNavigationProtocol {

    func makeConversationListNavigationController() -> UINavigationController {
        let conversationListAssembly = rootAssembly.conversationListAssembly

        let conversationListController = conversationListAssembly.makeConversationListModule(moduleOutput: self)

        let conversationListNavigationController =
        UINavigationController(
            rootViewController: conversationListController
        )
        conversationListNavigationController.overrideUserInterfaceStyle = .light
        conversationListNavigationController.view.backgroundColor = .white
        conversationListNavigationController.navigationBar.isTranslucent = false

        self.conversationListNavigationController = conversationListNavigationController

        conversationListController.tabBarItem = UITabBarItem(title:
        Resources.Strings.channel, image: Resources.Images.channel, tag: Tabs.channels.rawValue)
        return conversationListNavigationController
    }

    func makeSettingsNavigationController() -> UINavigationController {
        let settingsAssembly = rootAssembly.settingsAssembly

        let settingsController = settingsAssembly.makeSettingsModule()

        let settingsNavigationController =
        UINavigationController(
            rootViewController: settingsController
        )

        settingsNavigationController.overrideUserInterfaceStyle = .light
        settingsNavigationController.view.backgroundColor = .white
        settingsNavigationController.navigationBar.isTranslucent = false

        settingsController.tabBarItem = UITabBarItem(title: Resources.Strings.settings,
                                                     image: Resources.Images.settings,
                                                     tag: Tabs.profile.rawValue)

        return settingsNavigationController
    }

    func makeProfileNavigationController() -> UINavigationController {
        let profileAssembly = rootAssembly.profileAssembly

        let profileController = profileAssembly.makeProfileModule(moduleOutput: self, photoCollectionModuleOutput: self)

        let profileNavigationController =
        UINavigationController(
            rootViewController: profileController
        )

        profileNavigationController.overrideUserInterfaceStyle = .light
        profileNavigationController.view.backgroundColor = .white
        profileNavigationController.navigationBar.isTranslucent = false

        self.profileNavigationController = profileNavigationController

        let profileButton = UITabBarItem(title: Resources.Strings.profile,
                                         image: Resources.Images.profile,
                                         tag: Tabs.profile.rawValue)
        profileButton.accessibilityIdentifier = "profileButton"
        profileController.tabBarItem = profileButton
        return profileNavigationController
    }
}
