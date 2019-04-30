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
    
    // MARK: - Outlets - Views
    @IBOutlet var initialPopoverView: UIView!
    @IBOutlet var noAccessPopoverView: UIView!
    // MARK: - Outlets - Labels
    @IBOutlet weak var popoverLabel: UILabel!
    // MARK: - Actions
    @IBAction func iAcceptButtonPressed(_ sender: UIButton) {
        SettingsService.hasAcceptedConditions = true
        self.initialPopoverView.removeFromSuperview()
    }
    @IBAction func iRefuseButtonPressed(_ sender: UIButton) {
        if popoverLabel.text == TextAndString.shared.initialWarning {
            popoverLabel.text = TextAndString.shared.conditionMustBeAccepted
        } else {
            self.initialPopoverView.removeFromSuperview()
            self.view.addSubview(noAccessPopoverView)
            adaptNoAccessPopoverSize()
        }
    }
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        print("on load")
        print(SettingsService.hasBeenAlreadyConnected)
        print("on check")
        checkIfHasBeenAlreadyConnected(SettingsService.hasBeenAlreadyConnected)
        print("on change le staus")
        SettingsService.hasBeenAlreadyConnected = true
        checkIfConditionsAccepted(SettingsService.hasAcceptedConditions)
    }


}
    // MARK: - Extension
// Here to list all functions for viewDidLoad
extension InitialScreenViewController {
    /**
     Function that checks if the user has already been connected
     - Parameter notFirst : Bool
     */
    private func checkIfHasBeenAlreadyConnected(_ notFirst: Bool){
        if !notFirst {
            self.view.addSubview(initialPopoverView)
            adaptPopoverSize()
            popoverLabel.text = TextAndString.shared.initialWarning
        } else {
            print("warning has been already displayed")
        }
    }
    /**
     Function that checks if the user has already accepted conditions
     - Parameter accepted : Bool
     */
    private func checkIfConditionsAccepted(_ accepted: Bool){
        if !accepted {
            self.view.addSubview(initialPopoverView)
            adaptPopoverSize()
            popoverLabel.text = TextAndString.shared.conditionMustBeAccepted
        } else {
            print("conditions already accepted")
        }
    }
}
// Here to set up popover display
extension InitialScreenViewController {
    private func adaptPopoverSize() {
        initialPopoverView.frame.size.height = 2 * screenHeight/3
        initialPopoverView.bounds.size.width = 2 * screenWidth/3
        initialPopoverView.layer.cornerRadius = 30
        self.initialPopoverView.center = self.initialPopoverView.superview!.center
    }
    private func adaptNoAccessPopoverSize() {
        noAccessPopoverView.frame.size.height = 8 * screenHeight/10
        noAccessPopoverView.bounds.size.width = 8 * screenWidth/10
        noAccessPopoverView.layer.cornerRadius = 30
        noAccessPopoverView.center = self.noAccessPopoverView.superview!.center
    }
    
}

