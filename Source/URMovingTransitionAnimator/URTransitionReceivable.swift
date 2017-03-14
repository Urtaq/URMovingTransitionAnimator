//
//  URTransitionReceivable.swift
//  URMovingTransitionAnimator
//
//  Created by jegumhon on 2017. 2. 14..
//  Copyright © 2017년 chbreeze. All rights reserved.
//

import Foundation

public protocol URTransitionReceivable: class {
    var transitionView: UIView? { get set }

    func transitionFinishingFrame(startingFrame: CGRect) -> CGRect
    func makeTransitionView(originView: UIView)
    func removeTransitionView()
}

public extension URTransitionReceivable where Self: UIViewController {
    func makeTransitionView(originView: UIView) {
        if let view = self.transitionView {
            self.view.bringSubview(toFront: view)
        } else {
            self.view.addSubview(originView)

            self.transitionView = originView
        }
    }

    func removeTransitionView(duration: Double) {
        if let view = self.transitionView {
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 0.1
            }, completion: { (finish) in
                self.view.sendSubview(toBack: view)
            })
        }
    }
}
