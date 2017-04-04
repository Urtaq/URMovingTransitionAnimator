//
//  URMovingTransitionReceivable.swift
//  URMovingTransitionAnimator
//
//  Created by jegumhon on 2017. 2. 14..
//  Copyright © 2017년 chbreeze. All rights reserved.
//

import UIKit

public protocol URMovingTransitionReceivable: class {
    var transitionView: UIView? { get set }

    func transitionFinishingFrame(startingFrame: CGRect) -> CGRect
    func makeTransitionView(originView: UIView)
    func removeTransitionView(duration: Double, completion: (() -> Void)?)

    /// use this, if some gestures is conflicted with the screen pan gesture.
    func requireForTransitionGesture(toFail: UIGestureRecognizer)
}

public extension URMovingTransitionReceivable where Self: UIViewController {
    func makeTransitionView(originView: UIView) {
        self.view.addSubview(originView)

        self.transitionView = originView
    }

    func removeTransitionView(duration: Double, completion: (() -> Void)?) {
        if let view = self.transitionView {
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 0.0
            }, completion: { (finish) in
                self.view.sendSubview(toBack: view)

                guard let block = completion else { return }
                block()
            })
        }
    }

    func requireForTransitionGesture(toFail otherGestureRecognizer: UIGestureRecognizer) {
        if self.navigationController?.delegate is URMovingTransitionAnimatorDelegate {
            otherGestureRecognizer.require(toFail: (self.navigationController?.delegate as! URMovingTransitionAnimatorDelegate).movingTransitionViewController.panGesture)
        }
    }
}
