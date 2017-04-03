//
//  URMovingTransitionAnimatorDelegate.swift
//  URExampleMovingTransition
//
//  Created by DongSoo Lee on 2017. 3. 17..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

public class URMovingTransitionAnimatorDelegate: NSObject, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    var movingTransitionViewController: URMovingTransitionMakable!

    init(movingTransitionViewController: URMovingTransitionMakable) {
        super.init()

        self.movingTransitionViewController = movingTransitionViewController
    }

    func makeGesture() -> UIScreenEdgePanGestureRecognizer {
        let panGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(pan))
        panGesture.edges = .left
        panGesture.delegate = self

        return panGesture
    }

    public func pan(gesture: UIScreenEdgePanGestureRecognizer) {

        guard let view = self.movingTransitionViewController.navigationController?.view else { return }

        if gesture.state == .began {
            self.movingTransitionViewController.interactionController = UIPercentDrivenInteractiveTransition()
            if let viewControllers = self.movingTransitionViewController.navigationController?.viewControllers, viewControllers.count > 1 && self.movingTransitionViewController.navigationController?.topViewController is URMovingTransitionReceivable {
                _ = self.movingTransitionViewController.navigationController?.popViewController(animated: true)
            }
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: view)
            let d: CGFloat = fabs(translation.x / view.bounds.width)

            self.movingTransitionViewController.interactionController.update(d)
        } else if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            let translation = gesture.translation(in: view)
            let d: CGFloat = fabs(translation.x / view.bounds.width)

            if (gesture.velocity(in: view).x > 0 && d > 0.5) || d > 0.5 {
                self.movingTransitionViewController.interactionController.finish()
                print("######### finish")
            } else {
                self.movingTransitionViewController.interactionController.cancel(with: {
                    if let customAnimator = self.movingTransitionViewController.animator as? URMoveTransitioningAnimator {
                        customAnimator.movingView?.alpha = 0.0
                    }
                })
                print("######### cancel")
            }
            self.movingTransitionViewController.interactionController = nil
        }
    }

    // MARK: UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (operation == .push && toVC is URMovingTransitionReceivable) || operation == .pop {
            if let customAnimator = self.movingTransitionViewController.animator as? URMoveTransitioningAnimator {
                customAnimator.isConsiderableNavigationHeight = true
                customAnimator.transitionDirection = operation
            }
            return self.movingTransitionViewController.animator
        }

        return nil
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.movingTransitionViewController.interactionController
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if !(viewController is URMovingTransitionMakable) && !self.movingTransitionViewController.isPopableViewController {
            navigationController.delegate = nil
        }
    }

    // MARK: UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === self.movingTransitionViewController.panGesture && self.movingTransitionViewController.navigationController?.topViewController is URMovingTransitionReceivable {
            return true
        }
        
        return false
    }
}
