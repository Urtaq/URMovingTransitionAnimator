//
//  URMoveBlurredTransitioningAnimator.swift
//  URMovingTransitionAnimator
//
//  Created by jegumhon on 2017. 2. 16..
//  Copyright © 2017년 chbreeze. All rights reserved.
//

import Foundation

public class URMoveBlurredTransitioningAnimator: URMoveTransitioningAnimator {

    var fromViewSnapShot: UIView?
    var blurView: UIVisualEffectView?

    override func makeMovingKeyframe(_ movingView: UIView?, _ finishingFrame: CGRect) {
        print("override " + #function)
        super.makeMovingKeyframe(movingView, finishingFrame)

        let blurEffect = UIBlurEffect(style: .light)
//        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)

        self.blurView?.effect = blurEffect

        self.fromViewSnapShot?.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
    }

    func initBlurredView() {
        print(#function)
        self.blurView = UIVisualEffectView()

        self.transitionCompletion = { (transitionContext) in
            print("transitionCompletion called!!")

            self.blurView?.effect = nil
            self.fromViewSnapShot?.alpha = 0.0

            UIView.animate(withDuration: self.transitionFinishDuration, animations: {
                self.movingView?.alpha = 0.8
            }, completion: { (finish) in
                self.movingView?.removeFromSuperview()
                self.blurView?.removeFromSuperview()
                self.fromViewSnapShot?.removeFromSuperview()

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }

    override func initAnimationDescriptor(using transitionContext: UIViewControllerContextTransitioning) -> CGRect {
        print("override " + #function)
        let finishingFrame = super.initAnimationDescriptor(using: transitionContext)

        self.initBlurredView()
        guard let blurredView = self.blurView, let movedView = self.movingView else { return finishingFrame }
        blurredView.frame = UIScreen.main.bounds
        transitionContext.containerView.insertSubview(blurredView, belowSubview: movedView)

        if let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) {
            self.fromViewSnapShot = fromViewController.view.snapshotView(afterScreenUpdates: false)!
            transitionContext.containerView.insertSubview(self.fromViewSnapShot!, belowSubview: blurredView)
        }
        
        return finishingFrame
    }
}
