//
//  URMovingTransitionViewController.swift
//  URMovingTransitionAnimator
//
//  Created by jegumhon on 2017. 2. 8..
//  Copyright © 2017년 chbreeze. All rights reserved.
//

import UIKit

open class URMovingTransitionViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    var panGesture: UIScreenEdgePanGestureRecognizer!

    public var animator: UIViewControllerAnimatedTransitioning?
    var interactionController: UIPercentDrivenInteractiveTransition!

    var checkPopableViewController: Bool {
        guard let navigationController = self.navigationController else { return false }

        let navigationStackCount = navigationController.viewControllers.count
        if navigationStackCount > 1 {
            if navigationController.viewControllers[navigationStackCount - 2] is URMovingTransitionViewController {
                return true
            }
        }

        return false
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.panGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(pan))
        self.panGesture.edges = .left
        self.panGesture.delegate = self
        self.navigationController?.view.addGestureRecognizer(self.panGesture)

        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.delegate = self
    }

    deinit {
        self.navigationController?.view.removeGestureRecognizer(self.panGesture)
    }

    func pan(gesture: UIScreenEdgePanGestureRecognizer) {

        guard let view = self.navigationController?.view else { return }

        if gesture.state == .began {
            self.interactionController = UIPercentDrivenInteractiveTransition()
            if let viewControllers = self.navigationController?.viewControllers, viewControllers.count > 1 && self.navigationController?.topViewController is URTransitionReceivable {
                _ = self.navigationController?.popViewController(animated: true)
            }
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: view)
            let d: CGFloat = fabs(translation.x / view.bounds.width)

            self.interactionController.update(d)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: view)
            let d: CGFloat = fabs(translation.x / view.bounds.width)

            if gesture.velocity(in: view).x > 0 || d > 0.5 {
                self.interactionController.finish()
                print("######### finish")
            } else {
                self.interactionController.cancel(with: {
                    if let customAnimator = self.animator as? URMoveTransitioningAnimator {
                        customAnimator.movingView?.alpha = 0.0
                    }
                })
                print("######### cancel")
            }
            self.interactionController = nil
        }
    }

    // MARK: - UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push || operation == .pop {
            if let customAnimator = self.animator as? URMoveTransitioningAnimator {
                customAnimator.isConsiderableNavigationHeight = true
                customAnimator.transitionDirection = operation
            }
            return self.animator
        }

        return nil
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if !(viewController is URMovingTransitionViewController) && !self.checkPopableViewController {
            navigationController.delegate = nil
        }
    }

    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === self.panGesture && self.navigationController?.topViewController is URTransitionReceivable {
            return true
        }

        return false
    }
}
