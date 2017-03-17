# URMovingTransitionAnimator

[![podplatform](https://cocoapod-badges.herokuapp.com/p/URMovingTransitionAnimator/badge.png)](https://cocoapod-badges.herokuapp.com/p/URMovingTransitionAnimator/badge.png) ![pod](https://cocoapod-badges.herokuapp.com/v/URMovingTransitionAnimator/badge.png) ![license](https://cocoapod-badges.herokuapp.com/l/URMovingTransitionAnimator/badge.png) ![travis](https://travis-ci.org/jegumhon/URMovingTransitionAnimator.svg?branch=master) [![codecov](https://codecov.io/gh/jegumhon/URMovingTransitionAnimator/branch/master/graph/badge.svg)](https://codecov.io/gh/jegumhon/URMovingTransitionAnimator) [![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat)](https://github.com/CocoaPods/CocoaPods)

## What is this?
Moving view transition with the blurring effect between view controllers for **Swift3**  
This code style is the **`Protocol Oriented Programming`**.  
So you don't need to inherit. Just Implement protocols.  
You can handle some parameter to customize this transition. e.g. scale, duration, etc.

![sample1](https://github.com/jegumhon/URMovingTransitionAnimator/blob/master/Resources/URMovingTransitionAnimator1.gif)![sample1](https://github.com/jegumhon/URMovingTransitionAnimator/blob/master/Resources/URMovingTransitionAnimator2-gesture.gif)

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
            self.makeTransitionAnimator(target: cell.imgView, baseOn: tableView.superview!, duration: 0.8)
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

## License

URMovingTransitionAnimator is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
