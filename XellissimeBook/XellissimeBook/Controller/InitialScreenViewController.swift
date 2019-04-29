//
//  ViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 29/04/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

class InitialScreenViewController: UIViewController {

    // Elements of the initial Popover View
    @IBOutlet var initialPopoverView: UIView!
    @IBOutlet weak var popoverLabel: UILabel!
    @IBAction func iAcceptButtonPressed(_ sender: UIButton) {
    }
    @IBAction func iRefuseButtonPressed(_ sender: UIButton) {
        self.initialPopoverView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("on load")
        print(SettingsService.hasBeenAlreadyConnected)
        print("on check")
        checkIfHasBeenAlreadyConnected(SettingsService.hasBeenAlreadyConnected)
        print("on change le staus")
        SettingsService.hasBeenAlreadyConnected = true
    }


}
// Here to list all function for viewDidLoad
extension InitialScreenViewController {
    private func checkIfHasBeenAlreadyConnected(_ notFirst: Bool){
        if !notFirst {
            self.view.addSubview(initialPopoverView)
            adaptPopoverSize()
            popoverLabel.text = TextAndString.shared.initialWarning
        } else {
            print("warning has been already displayed")
        }
    }
    private func checkIfConditionsAccepted(_ accepted: Bool){
        if !accepted {
            self.view.addSubview(initialPopoverView)
            adaptPopoverSize()
            popoverLabel.text = TextAndString.shared.conditionMustBeAccepted
        } else {
            print("condition already accepted")
        }
    }
}
// Here to set up popover display
extension InitialScreenViewController {
    // Here to set up popover display
    private func adaptPopoverSize() {
        initialPopoverView.frame.size.height = 2 * screenHeight/3
        initialPopoverView.bounds.size.width = 2 * screenWidth/3
        initialPopoverView.layer.cornerRadius = 30
        self.initialPopoverView.center = self.initialPopoverView.superview!.center
    }
    
    
}

