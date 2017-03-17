//
//  URExampleDetailViewController.swift
//  URExampleMovingTransition
//
//  Created by DongSoo Lee on 2017. 3. 14..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import URMovingTransitionAnimator

class URExampleDetailViewController: UIViewController, URMovingTransitionReceivable {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lbText: UILabel!

    var image: UIImage!
    var text: String!

    var transitionView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgView.image = self.image
        self.lbText.text = self.text

        self.imgView.contentMode = .scaleAspectFit
    }

    func transitionFinishingFrame(startingFrame: CGRect) -> CGRect {
        self.imgView.layoutIfNeeded()
        let frame = self.imgView.frame
        let finishingFrame = CGRect(origin: CGPoint(x: 0, y: 64), size: frame.size)

        return finishingFrame
    }
}
