//
//  ViewController.swift
//  URExampleMovingTransition
//
//  Created by DongSoo Lee on 2017. 3. 14..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import URMovingTransitionAnimator

class URExampleMasterViewController: URMovingTransitionViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

    var images: [UIImage] = [#imageLiteral(resourceName: "suzy1"), #imageLiteral(resourceName: "suzy2"), #imageLiteral(resourceName: "sulhyun1"), #imageLiteral(resourceName: "sulhyun2"), #imageLiteral(resourceName: "sulhyun3"), #imageLiteral(resourceName: "sulhyun4")]
    var strings: [String] = ["Oriental Style Suzy", "Suzy who grapped a mic", "SeolHyun in swimming suit", "SeolHyun with hand bag", "Standing SeolHyun", "Laying down SeolHyun"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let vc = segue.destination as? URExampleDetailViewController, let cell = sender as? URExampleTableViewCell else { return }

            vc.image = cell.imgView.image
            vc.text = cell.lbText.text
        }
    }

    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        if let navigationDelegate = self.navigationController?.delegate as? URMovingTransitionViewController, let cell = tableView.cellForRow(at: indexPath) as? URExampleTableViewCell {
            var view: UIView = cell.imgView
            var originRect: CGRect = cell.contentView.convert(cell.contentView.frame, to: tableView.superview)

            view = UIImageView(image: cell.imgView.image)
            view.backgroundColor = #colorLiteral(red: 1, green: 0.6998770833, blue: 0.0003534180869, alpha: 1)
            view.contentMode = cell.imgView.contentMode
            view.frame = cell.imgView.frame

            originRect = cell.imgView.convert(view.frame, to: tableView.superview)

            navigationDelegate.animator = URMoveBlurredTransitioningAnimator(view: view, startingOrigin: originRect.origin)
        }

        self.performSegue(withIdentifier: "showDetail", sender: tableView.cellForRow(at: indexPath))
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! URExampleTableViewCell

        cell.config(image: self.images[indexPath.row], text: self.strings[indexPath.row])

        return cell
    }
}

