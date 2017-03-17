//
//  URMoveTransitioningAnimator.swift
//  URMovingTransitionAnimator
//
//  Created by jegumhon on 2017. 2. 8..
//  Copyright © 2017년 chbreeze. All rights reserved.
//

import UIKit

let URMovingAnimationKey = "movingAnimationKey"

public class URMoveTransitioningAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate var _movingView: UIView?
    var movingView: UIView? {
        get {
            return self._movingView
        }
        set {
            guard let newView = newValue else {
                self._movingView = nil
                return
            }

//            let view = UIView(frame: newView.frame)
            self._movingLayer = newView.layer
            self._movingLayer.contentsGravity = newView.layer.contentsGravity

//            view.addSubview(newView)
//            view.clipsToBounds = true

//            newView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleWidth, .flexibleHeight]

//            self._movingView = view
            self._movingView = newView
        }
    }

    fileprivate var _movingLayer: CALayer!

    var startingSize: CGSize = CGSize.zero

    fileprivate var _startingPoint: CGPoint = CGPoint(x: 0, y: 64)
    var startingPoint: CGPoint {
        get {
            return self._startingPoint
        }
        set {
            if self.isConsiderableNavigationHeight {
                if newValue != CGPoint.zero && newValue.y >= 64 {
                    self._startingPoint = newValue
                }
            } else {
                self._startingPoint = newValue
            }
        }
    }

    fileprivate var _preFinishingFrame: CGRect = CGRect.zero
    var finishingFrame: CGRect = CGRect.zero

    var desiredFinishingSize: CGSize = CGSize.zero
    var desiredFinishingContentMode: UIViewContentMode = .scaleToFill

    var isConsiderableNavigationHeight: Bool = true
    var transitionDirection: UINavigationControllerOperation = .none
    var transitionDuration: TimeInterval = 0.25
    var transitionFinishDuration: TimeInterval = 0.8
    var scale: CGFloat = 1.0

    var transitionPreAction: (() -> Void)?
    var transitionCompletion: ((_ transitionContext: UIViewControllerContextTransitioning) -> Void)?
    var isLazyCompletion: Bool = false

    var transitionContext: UIViewControllerContextTransitioning!

    public init(target view: UIView, basedOn viewForStartingFrameCaculation: UIView?, isLazyCompletion: Bool = false, duration: TimeInterval = 0.25, finishingDuration: TimeInterval = 0.8) {
        super.init()

        self.movingView = self.copyView(view: view)

        let startingOrigin = view.convert(view.frame, to: viewForStartingFrameCaculation)
        self.startingPoint = startingOrigin.origin
        self.startingSize = view.bounds.size

        self.transitionDuration = duration
        self.transitionFinishDuration = finishingDuration
        self.isLazyCompletion = isLazyCompletion
    }

    /// make copied view to remove the reference of original view, because of the side effects related on the original view
    func copyView(view: UIView) -> UIView {
        if view is UIImageView {
            return self.copyView(imageView: view as! UIImageView)
        }

        let view = view.snapshotView(afterScreenUpdates: false)!

        return view
    }

    func copyView(imageView: UIImageView) -> UIImageView {
        let view = UIImageView(image: imageView.image)
        view.backgroundColor = imageView.backgroundColor
        view.contentMode = imageView.contentMode
        view.frame = imageView.frame
        
        return view
    }

    public init(view: UIView, startingFrame: CGRect = CGRect.zero, isLazyCompletion: Bool = false, duration: TimeInterval = 0.25, finishingDuration: TimeInterval = 0.8) {
        super.init()

        self.movingView = view
        self.startingPoint = startingFrame.origin
        self.startingSize = startingFrame.size

        self.transitionDuration = duration
        self.transitionFinishDuration = finishingDuration
        self.isLazyCompletion = isLazyCompletion
    }

    public init(view: UIView, startingOrigin: CGPoint = CGPoint.zero, isLazyCompletion: Bool = false, duration: TimeInterval = 0.25, finishingDuration: TimeInterval = 0.8) {
        super.init()

        self.movingView = view
        self.startingPoint = startingOrigin
        self.startingSize = view.bounds.size

        self.transitionDuration = duration
        self.transitionFinishDuration = finishingDuration
        self.isLazyCompletion = isLazyCompletion
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        self.transitionContext = transitionContext

        let finishingFrame = self.initAnimationDescriptor(using: transitionContext)

        self.startAnimation(using: transitionContext, finishingFrame: finishingFrame)
    }

    func initAnimationDescriptor(using transitionContext: UIViewControllerContextTransitioning) -> CGRect {

        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return .zero }
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return .zero }

        var movingViewFrame: CGRect = CGRect.zero

        if self.transitionDirection == .push {
            transitionContext.containerView.addSubview(toViewController.view)

            toViewController.view.alpha = 0.0

            if let movedView = self.movingView {
                transitionContext.containerView.addSubview(movedView)
                movingViewFrame = movedView.frame
                movingViewFrame.origin = self.startingPoint
                movedView.frame = movingViewFrame
            }

            if toViewController is URTransitionReceivable {
                self.finishingFrame = (toViewController as! URTransitionReceivable).transitionFinishingFrame(startingFrame: movingViewFrame)
            } else {
                self.finishingFrame = movingViewFrame
            }

            if self.desiredFinishingSize != .zero {
                self.finishingFrame.size = self.desiredFinishingSize
            }
        } else if self.transitionDirection == .pop {
            transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

            _preFinishingFrame = self.finishingFrame

            if let movedView = self.movingView {
                transitionContext.containerView.addSubview(movedView)
                movedView.alpha = 1.0

                if toViewController is URTransitionReceivable {
                    self.finishingFrame = (toViewController as! URTransitionReceivable).transitionFinishingFrame(startingFrame: movingViewFrame)
                } else {
                    self.finishingFrame = movedView.frame
                    self.finishingFrame.origin = self.startingPoint
                    self.finishingFrame.size = self.startingSize
                }
            }
        }

        self.transitionCompletion = { (transitionContext) in

            guard let movedView = self.movingView else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
            }

            if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to), toViewController is URTransitionReceivable && !self.isLazyCompletion {
                (toViewController as! URTransitionReceivable).removeTransitionView(duration: self.transitionFinishDuration)
            }

            UIView.animate(withDuration: self.transitionFinishDuration, animations: {
                movedView.alpha = 0.1
            }, completion: { (finish) in
                movedView.removeFromSuperview()

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }

        return self.finishingFrame
    }

    fileprivate var _prePosition: CGPoint = CGPoint.zero
    fileprivate var _preBounds: CGRect = CGRect.zero

    fileprivate var _moveAnimation: CABasicAnimation!
    var moveAnimation: CABasicAnimation! {
        guard let movedView = self.movingView else { return nil }

        let timingFunction = CAMediaTimingFunction(controlPoints: 5/6, 0.1, 1/6, 0.9)
        let duration = self.transitionDuration(using: self.transitionContext)

        _moveAnimation = CABasicAnimation(keyPath: "position")

        _moveAnimation.timingFunction = timingFunction

        _moveAnimation.fromValue = movedView.layer.position
        _prePosition = _movingLayer.position
        _moveAnimation.toValue = CGPoint(x: (self.finishingFrame.origin.x + (self.finishingFrame.width / 2.0)), y: (self.finishingFrame.origin.y + (self.finishingFrame.height / 2.0)))
        _moveAnimation.duration = duration

        _moveAnimation.fillMode = kCAFillModeForwards
        _moveAnimation.isRemovedOnCompletion = false

        return _moveAnimation
    }

    fileprivate var _scaleAnimation: CABasicAnimation!
    var scaleAnimation: CABasicAnimation! {
        guard let _ = self.movingView else { return nil }

        self.makeScaleAnimation(target: _movingLayer)

        return _scaleAnimation
    }

    func makeScaleAnimation(target: CALayer) {
        guard let _ = self.movingView else { return }

        let timingFunction = CAMediaTimingFunction(controlPoints: 5/6, 0.1, 1/6, 0.9)
        let duration = self.transitionDuration(using: self.transitionContext)

        _scaleAnimation = CABasicAnimation(keyPath: "bounds")

        _scaleAnimation.timingFunction = timingFunction

        _scaleAnimation.fromValue = target.bounds
        _preBounds = target.bounds
        _scaleAnimation.toValue = CGRect(origin: target.bounds.origin, size: self.finishingFrame.size)
        _scaleAnimation.duration = duration

        _scaleAnimation.fillMode = kCAFillModeForwards
        _scaleAnimation.isRemovedOnCompletion = false
    }

    func makeLayerAnimation(cancelled: Bool = false) {

        if cancelled {

        }
        
        if let _ = self.movingView {
            let animationGroup = CAAnimationGroup()
            animationGroup.animations = [self.moveAnimation, self.scaleAnimation]
            animationGroup.duration = self.transitionDuration(using: self.transitionContext)
            animationGroup.fillMode = kCAFillModeForwards
            animationGroup.isRemovedOnCompletion = false
            _movingLayer.add(animationGroup, forKey: URMovingAnimationKey)
        }
    }

    func stopLayerAnimation() {
        _movingLayer.removeAnimation(forKey: URMovingAnimationKey)
    }

    func completeLayerAnimation(cancelled: Bool = false) {
        if let movedView = self.movingView {
            if !cancelled {
                movedView.frame = finishingFrame
            } else {
                self.stopLayerAnimation()

                movedView.frame = _preFinishingFrame

                self.finishingFrame = _preFinishingFrame
            }
        }
    }

    func makeMovingKeyframe(_ movingView: UIView?, _ finishingFrame: CGRect, withRelativeStartTime: Double, relativeDuration: Double) -> Void {

        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
            if let movedView = movingView {
                movedView.transform = CGAffineTransform.identity
//                movedView.frame = finishingFrame
            }
        })
    }

    func startAnimation(using transitionContext: UIViewControllerContextTransitioning, finishingFrame: CGRect) {

        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }

        let basicAnimationBlock: () -> Void = {

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                if self.transitionDirection == .push {
                    toViewController.view.alpha = 1.0
                } else if self.transitionDirection == .pop {
                    fromViewController.view.alpha = 0.0
                }
            })

            if self.scale == 1 || self.transitionDirection == .pop {
                self.makeMovingKeyframe(self.movingView, finishingFrame, withRelativeStartTime: 0.0, relativeDuration: 1.0)
            } else {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6, animations: {
                    if let movedView = self.movingView {
                        movedView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
                    }
                })

                self.makeMovingKeyframe(self.movingView, finishingFrame, withRelativeStartTime: 0.6, relativeDuration: 0.4)
            }
        }

        let basicAnimationFinishedBlock: (Bool) -> Void = { (finish) in

            // prepare transition result view for the showing view controller
            self.completeLayerAnimation(cancelled: transitionContext.transitionWasCancelled)

            if let movedView = self.movingView, toViewController is URTransitionReceivable {
                let snapShotView = movedView.snapshotView(afterScreenUpdates: false)!
                snapShotView.frame = movedView.frame
                (toViewController as! URTransitionReceivable).makeTransitionView(originView: snapShotView)
            }

            guard let block = self.transitionCompletion else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
            }
            block(transitionContext)
        }

        self.makeLayerAnimation()
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: UIViewKeyframeAnimationOptions.calculationModeLinear, animations: basicAnimationBlock) { (finish) in
            basicAnimationFinishedBlock(finish)
        }
    }
}

extension UIPercentDrivenInteractiveTransition {
    func cancel(with completion: (() -> Void)?) {
        if let block = completion {
            block()
        }
        self.cancel()
    }
}
