//
//  EditProfileController+TransitionDelegate.swift
//  Messenger
//
//  Created by Андрей Лосюков on 04.05.2023.
//

import UIKit

extension EditProfileViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 2, animationType: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 2, animationType: .dismiss)
    }
}
