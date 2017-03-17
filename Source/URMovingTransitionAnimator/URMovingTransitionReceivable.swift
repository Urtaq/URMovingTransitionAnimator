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
    func removeTransitionView(duration: Double)
}

public extension URMovingTransitionReceivable where Self: UIViewController {
    func makeTransitionView(originView: UIView) {
        self.view.addSubview(originView)

        self.transitionView = originView
    }

    func removeTransitionView(duration: Double) {
        if let view = self.transitionView {
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 0.0
            }, completion: { (finish) in
                self.view.sendSubview(toBack: view)
            })
        }
    }
}
