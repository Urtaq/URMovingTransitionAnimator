# URMovingTransitionAnimator

 [![Swift](https://img.shields.io/badge/Swift-3.0%2B-orange.svg)](https://swift.org) [![podplatform](https://cocoapod-badges.herokuapp.com/p/URMovingTransitionAnimator/badge.png)](https://cocoapod-badges.herokuapp.com/p/URMovingTransitionAnimator/badge.png) [![pod](https://cocoapod-badges.herokuapp.com/v/URMovingTransitionAnimator/badge.png)](https://cocoapods.org/pods/URMovingTransitionAnimator) ![poddoc](https://img.shields.io/cocoapods/metrics/doc-percent/URMovingTransitionAnimator.svg) ![license](https://cocoapod-badges.herokuapp.com/l/URMovingTransitionAnimator/badge.png) ![travis](https://travis-ci.org/jegumhon/URMovingTransitionAnimator.svg?branch=master) [![codecov](https://codecov.io/gh/jegumhon/URMovingTransitionAnimator/branch/master/graph/badge.svg)](https://codecov.io/gh/jegumhon/URMovingTransitionAnimator) [![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat)](https://github.com/CocoaPods/CocoaPods)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fjegumhon%2FURMovingTransitionAnimator.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fjegumhon%2FURMovingTransitionAnimator?ref=badge_shield)


[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fjegumhon%2FURMovingTransitionAnimator.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fjegumhon%2FURMovingTransitionAnimator?ref=badge_large)

## What is this?
Moving view transition with the blurring effect between view controllers for **Swift3**  
This code style is the **`Protocol Oriented Programming`**.  
So you don't need to inherit. Just Implement protocols.  
You can handle some parameter to customize this transition. e.g. scale, duration, etc.

![sample1](https://github.com/jegumhon/URMovingTransitionAnimator/blob/master/Resources/URMovingTransitionAnimator1.gif)![sample1](https://github.com/jegumhon/URMovingTransitionAnimator/blob/master/Resources/URMovingTransitionAnimator2_gesture.gif)

## Requirements

* iOS 8.1+
* Swift 3.0+

## Installation

### Cocoapods

Add the following to your `Podfile`.

    pod "URMovingTransitionAnimator"

## Examples

See the `Example` folder.  
Run `pod install` and open the .xcworkspace file.

## Usage

```swift
import URMovingTransitionAnimator
```

#### 1. Set the transition initialization in the transition starting viewcontroller

```swift
class viewController: UIViewController, URMovingTransitionMakable {
    ...
    override func viewDidLoad() {
        super.viewDidload()
        
        self.initMovingTrasitionGesture()
        
        ...
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.initMovingTransitionNavigationDelegate()
        
        ...
    }

    deinit {
        self.removeMovingTransitionGesture()
        
        ...
    }
    
    ...

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ...

        if let cell = tableView.cellForRow(at: indexPath) as? URExampleTableViewCell {
            self.makeBlurredTransitionAnimator(target: cell.imgView, baseOn: tableView.superview!, duration: 0.8)
            
            // if you want to add scaling animation, use makeTransitionAnimator function like below
            // At the beginning, the scaling animation will be showed!!
            // self.makeBlurredTransitionAnimator(target: cell.imgView, baseOn: tableView.superview!, duration: 0.8, needScaleEffect: true, scale: 1.05)
            
            // if you want to transition without the blur effect, you can use this make function!!
            // self.makeTransitionAnimator(target: cell.imgView, baseOn: tableView.superview!, duration: 0.8, needScaleEffect: true, scale: 1.05)
        }
        
        ...

        // push view controller
    }
    
    ...
}
```

#### 2. Set the destination frame in the transition finishing view controller

```swift
class finishViewController: UIViewController, URMovingTransitionReceivable {
    ...
    
    var transitionView: UIView?
    
    ...
    
    func transitionFinishingFrame(startingFrame: CGRect) -> CGRect {
        let frame = {view's frame to be the destination}
        let finishingFrame = CGRect(origin: CGPoint(x: 0, y: 64), size: frame.size)

        return finishingFrame
    }
    
    ...
}
```

#### 3. 😀 Configurable parameters of UIMovingTransitionAnimator 😀
* whether you need to clip the bounds of target view
* scale up or down effect  
  * This is applied at the beginning of transition. 
  * For using this, you need to set the scale value over 1.0 or below 1.0
* finishing animation duration
* finishing animation duration for the Pop transition
* whether you need to run the whole transition completion callback right away after finishing the transition

## To-Do

- [ ] refactoring the initailization for the convenient usage

## License

URMovingTransitionAnimator is available under the MIT license. See the [LICENSE](LICENSE) file for more info.