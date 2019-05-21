//
//  MenuTabBarViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

class MenuTabBarViewController: UITabBarController {

    @IBOutlet weak var menu: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

//extension UITabBar {
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 100 // adjust your size here
//        return sizeThatFits
//    }
//}
