//
//  URMoveBlurredTransitioningAnimator.swift
//  URMovingTransitionAnimator
//
//  Created by jegumhon on 2017. 2. 16..
//  Copyright © 2017년 chbreeze. All rights reserved.
//

import UIKit

public class URMoveBlurredTransitioningAnimator: URMoveTransitioningAnimator {

    var fromViewSnapShot: UIView?
    var blurView: UIVisualEffectView?

    override func makeMovingKeyframe(_ movingView: UIView?, _ finishingFrame: CGRect, withRelativeStartTime: Double, relativeDuration: Double) {

        super.makeMovingKeyframe(movingView, finishingFrame, withRelativeStartTime: withRelativeStartTime, relativeDuration: relativeDuration)

        UIView.addKeyframe(withRelativeStartTime: withRelativeStartTime, relativeDuration: relativeDuration / 2.0) {
            let blurEffect = UIBlurEffect(style: .light)
//            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)

            self.blurView?.effect = blurEffect
        }

        UIView.addKeyframe(withRelativeStartTime: withRelativeStartTime + relativeDuration / 2.0, relativeDuration: relativeDuration / 2.0) { 
            self.blurView?.effect = nil
        }

        UIView.addKeyframe(withRelativeStartTime: withRelativeStartTime, relativeDuration: relativeDuration) {

            self.fromViewSnapShot?.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            self.fromViewSnapShot?.alpha = 0.0
        }
    }

    func initBlurredView() {

        self.blurView = UIVisualEffectView()

        self.transitionCompletion = { (transitionContext) in

            if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to), toViewController is URMovingTransitionReceivable && !self.isLazyCompletion {
                (toViewController as! URMovingTransitionReceivable).removeTransitionView(duration: self.transitionFinishDuration)
            }

            UIView.animate(withDuration: self.transitionFinishDuration, animations: {
                if !transitionContext.transitionWasCancelled {
                    self.movingView?.alpha = 0.8
                }
            }, completion: { (finish) in
                self.movingView?.removeFromSuperview()
                self.blurView?.removeFromSuperview()
                self.fromViewSnapShot?.removeFromSuperview()

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }

    override func initAnimationDescriptor(using transitionContext: UIViewControllerContextTransitioning) -> CGRect {

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
