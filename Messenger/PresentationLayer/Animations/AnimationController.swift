//
//  AnimationController.swift
//  Messenger
//
//  Created by Андрей Лосюков on 04.05.2023.
//

import UIKit

enum TypeOfAnimation {
    case present
    case dismiss
}

class AnimationController: NSObject {
    private let animationDuration: Double
    private let animationType: TypeOfAnimation

    init(animationDuration: Double, animationType: TypeOfAnimation) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return TimeInterval(exactly: animationDuration) ?? 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }

        switch animationType {
        case .dismiss:
            transitionContext.containerView.addSubview(fromViewController.view)
            dismissAnimation(with: transitionContext, viewToAnimate: fromViewController.view)
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
        }
    }

    func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        viewToAnimate.clipsToBounds = true
        let duration = transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration) {
                viewToAnimate.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            }
        }, completion: {_ in
            transitionContext.completeTransition(true)
        })
    }

    func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        viewToAnimate.clipsToBounds = true
        viewToAnimate.transform = CGAffineTransform(scaleX: 0, y: 0)
        let duration = transitionDuration(using: transitionContext)
        let viewControllerToAnimate = transitionContext.viewController(forKey:
        UITransitionContextViewControllerKey.to) ?? UIViewController()
        let finalFrame = transitionContext.finalFrame(for: viewControllerToAnimate)
        viewToAnimate.layer.cornerRadius = 10
        UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration / 2) {
                viewToAnimate.alpha = 0.0
            }

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration / 2) {
                viewToAnimate.transform = CGAffineTransform(rotationAngle: .pi)
            }

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration) {
                viewToAnimate.transform = CGAffineTransform(rotationAngle: -.pi)
                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
                viewToAnimate.frame = finalFrame
                viewToAnimate.alpha = 1.0
            }
        }, completion: {_ in
            transitionContext.completeTransition(true)
        })
    }
}
