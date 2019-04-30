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
    @IBOutlet weak var mainLabel: UILabel!
    // MARK: - Actions
    @IBAction func iAcceptButtonPressed(_ sender: UIButton) {
        SettingsService.hasAcceptedConditions = true
        self.initialPopoverView.removeFromSuperview()
        mainLabel.isHidden = false
    }
    @IBAction func iRefuseButtonPressed(_ sender: UIButton) {
        print("User has pressed refused button")
        if popoverLabel.text == TextAndString.shared.initialWarning {
            initialPopoverView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            popoverLabel.text = TextAndString.shared.conditionMustBeAccepted
        } else {
            self.initialPopoverView.removeFromSuperview()
            self.view.addSubview(noAccessPopoverView)
            adaptNoAccessPopoverSize()
 
        }
    }
    @IBAction func backButtonIsPressed(_ sender: UIButton) {
        self.noAccessPopoverView.removeFromSuperview()
        checkIfConditionsAccepted(SettingsService.hasAcceptedConditions)
    }
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        mainLabel.isHidden = true
        print("on load: est ce que le user a deja été connecté?")
        print(SettingsService.hasBeenAlreadyConnected)
        print("on check")
        checkIfHasBeenAlreadyConnected(SettingsService.hasBeenAlreadyConnected)
        print("on change le status")
        SettingsService.hasBeenAlreadyConnected = true
        
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
            print("première connection")
     //       checkIfConditionsAccepted(SettingsService.hasAcceptedConditions)
        } else {
            print("autre connection")
            print("warning has been already displayed")
            checkIfConditionsAccepted(SettingsService.hasAcceptedConditions)
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
            initialPopoverView.backgroundColor = .orange
            popoverLabel.text = TextAndString.shared.conditionMustBeAccepted
        } else {
            mainLabel.isHidden = false
            print("conditions already accepted")
        }
    }
}
// Here to set up popover display
extension InitialScreenViewController {
    private func adaptPopoverSize() {
        initialPopoverView.frame.size.height = 2 * screenHeight / 3
        initialPopoverView.bounds.size.width = 2 * screenWidth / 3
        initialPopoverView.layer.cornerRadius = popoverRoundRadius
        self.initialPopoverView.center = self.initialPopoverView.superview!.center
    }
    private func adaptNoAccessPopoverSize() {
        noAccessPopoverView.frame.size.height = 2 * screenHeight/3
        noAccessPopoverView.bounds.size.width = 2 * screenWidth/3
        noAccessPopoverView.layer.cornerRadius = popoverRoundRadius
        self.noAccessPopoverView.center = self.noAccessPopoverView.superview!.center
    }
}

