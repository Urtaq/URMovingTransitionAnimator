//
//  URExampleTableViewCell.swift
//  URExampleMovingTransition
//
//  Created by DongSoo Lee on 2017. 3. 14..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

class URExampleTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lbText: UILabel!

    func config(image: UIImage, text: String) {
        self.imgView.contentMode = .scaleAspectFit
        self.imgView.image = image
        self.lbText.text = text
    }
}
