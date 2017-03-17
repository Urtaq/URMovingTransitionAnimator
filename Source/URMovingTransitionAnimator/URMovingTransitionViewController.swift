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

    func isPopableViewController() -> Bool
    func makeTransitionAnimator(target: UIView, baseOn: UIView, duration: Double)
}

extension URMovingTransitionMakable where Self: UIViewController {

    var navigationController: UINavigationController? {
        return self.navigationController
    }

    public func isPopableViewController() -> Bool {
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

    public func makeTransitionAnimator(target: UIView, baseOn: UIView, duration: Double) {
        if let _ = self.navigationController?.delegate as? URMovingTransitionAnimatorDelegate {
            self.animator = URMoveBlurredTransitioningAnimator(target: target, basedOn: baseOn, duration: duration)
        }
    }
}
