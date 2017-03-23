//
//  URMovingTransitionViewController.swift
//  URMovingTransitionAnimator
//
//  Created by jegumhon on 2017. 2. 8..
//  Copyright © 2017년 chbreeze. All rights reserved.
//

import UIKit

public protocol URMovingTransitionMakable: class {
    var panGesture: UIScreenEdgePanGestureRecognizer! { get set }

    var animator: UIViewControllerAnimatedTransitioning? { get set }
    var interactionController: UIPercentDrivenInteractiveTransition! { get set }

    var movingTransitionDelegate: URMovingTransitionAnimatorDelegate! { get set }
    var navigationController: UINavigationController? { get }
    var isPopableViewController: Bool { get }

    func makeTransitionAnimator(target: UIView, baseOn: UIView, duration: Double, needClipToBounds: Bool, scale: CGFloat, finishingDuration: TimeInterval, finishingDurationForPop: TimeInterval, isLazyCompletion: Bool)
    func makeBlurredTransitionAnimator(target: UIView, baseOn: UIView, duration: Double, needClipToBounds: Bool, scale: CGFloat, finishingDuration: TimeInterval, finishingDurationForPop: TimeInterval, isLazyCompletion: Bool)
}

extension URMovingTransitionMakable where Self: UIViewController {

    var navigationController: UINavigationController? {
        return self.navigationController
    }

    public var isPopableViewController: Bool {
        guard let navigationController = self.navigationController else { return false }

        let navigationStackCount = navigationController.viewControllers.count
        if navigationStackCount > 1 {
            if navigationController.viewControllers[navigationStackCount - 2] is URMovingTransitionMakable {
                return true
            }
        }

        return false
    }

    /// recommend to call at viewDidLoad
    public func initMovingTrasitionGesture() {

        self.movingTransitionDelegate = URMovingTransitionAnimatorDelegate(movingTransitionViewController: self)

        self.panGesture = self.movingTransitionDelegate.makeGesture()
        self.navigationController?.view.addGestureRecognizer(self.panGesture)

        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    /// need to call at viewWillAppear
    public func initMovingTransitionNavigationDelegate() {
        self.navigationController?.delegate = self.movingTransitionDelegate
    }

    /// recommend to call at deinit
    public func removeMovingTransitionGesture() {
        self.navigationController?.view.removeGestureRecognizer(self.panGesture)
    }

    public func makeTransitionAnimator(target: UIView, baseOn: UIView, duration: Double, needClipToBounds: Bool = false, scale: CGFloat = 1.0, finishingDuration: TimeInterval = 0.8, finishingDurationForPop: TimeInterval = 0.2, isLazyCompletion: Bool = false) {
        if let _ = self.navigationController?.delegate as? URMovingTransitionAnimatorDelegate {
            self.animator = URMoveTransitioningAnimator(target: target, basedOn: baseOn, needClipToBounds: needClipToBounds, duration: duration, finishingDuration: finishingDuration, finishingDurationForPop: finishingDurationForPop, isLazyCompletion: isLazyCompletion)
            if scale != 1.0 {
                (self.animator as! URMoveTransitioningAnimator).scale = scale
            }
        }
    }

    public func makeBlurredTransitionAnimator(target: UIView, baseOn: UIView, duration: Double, needClipToBounds: Bool = false, scale: CGFloat = 1.0, finishingDuration: TimeInterval = 0.8, finishingDurationForPop: TimeInterval = 0.2, isLazyCompletion: Bool = false) {
        if let _ = self.navigationController?.delegate as? URMovingTransitionAnimatorDelegate {
            self.animator = URMoveBlurredTransitioningAnimator(target: target, basedOn: baseOn, needClipToBounds: needClipToBounds, duration: duration, finishingDuration: finishingDuration, finishingDurationForPop: finishingDurationForPop, isLazyCompletion: isLazyCompletion)
            if scale != 1.0 {
                (self.animator as! URMoveTransitioningAnimator).scale = scale
            }
        }
    }
}
