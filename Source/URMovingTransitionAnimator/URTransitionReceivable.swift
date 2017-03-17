//
//  URTransitionReceivable.swift
//  URMovingTransitionAnimator
//
//  Created by jegumhon on 2017. 2. 14..
//  Copyright © 2017년 chbreeze. All rights reserved.
//

import UIKit

public protocol URTransitionReceivable: class {
    var transitionView: UIView? { get set }

    func transitionFinishingFrame(startingFrame: CGRect) -> CGRect
    func makeTransitionView(originView: UIView)
    func removeTransitionView(duration: Double)
}

public extension URTransitionReceivable where Self: UIViewController {
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
