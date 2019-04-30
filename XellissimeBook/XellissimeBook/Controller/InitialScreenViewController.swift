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
    @IBOutlet weak var logStackView: UIStackView!
    // MARK: - Outlets - Labels
    @IBOutlet weak var popoverLabel: UILabel!
    @IBOutlet weak var alreadyAccountLabel: UILabel!
    // MARK: - Outlets - TextFields
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    // MARK: - Actions
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBAction func iAcceptButtonPressed(_ sender: UIButton) {
        SettingsService.hasAcceptedConditions = true
        self.initialPopoverView.removeFromSuperview()
       outletDisplay(shown: true)
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
        setUpPageLogIn()
        outletDisplay(shown: false)
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
         //   outletDisplay(shown: false)
            self.view.addSubview(initialPopoverView)
            adaptPopoverSize()
            initialPopoverView.backgroundColor = .orange
            popoverLabel.text = TextAndString.shared.conditionMustBeAccepted
        } else {
            print("conditions already accepted")
         outletDisplay(shown: true)
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

extension InitialScreenViewController {
    private func setUpPageLogIn(){
        userNameTextField.backgroundColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        userNameTextField.textColor = #colorLiteral(red: 0.5201328993, green: 0.5498541594, blue: 0.5580087304, alpha: 1)
        passwordTextField.backgroundColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        passwordTextField.textColor = #colorLiteral(red: 0.5201328993, green: 0.5498541594, blue: 0.5580087304, alpha: 1)
        emailTextField.backgroundColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        emailTextField.textColor = #colorLiteral(red: 0.5201328993, green: 0.5498541594, blue: 0.5580087304, alpha: 1)
        
        logInButton.layer.cornerRadius = 20
        logInButton.layer.borderWidth = 3
        logInButton.layer.borderColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        signUpButton.layer.cornerRadius = 20
        
    }
    
    private func outletDisplay(shown: Bool){
        if shown == true {
            self.logStackView.isHidden = !shown
            self.signUpButton.isHidden = !shown
            self.alreadyAccountLabel.isHidden = !shown
            self.logInButton.isHidden = !shown
        } else {
            self.logStackView.isHidden = true
            self.signUpButton.isHidden = true
            self.alreadyAccountLabel.isHidden = true
            self.logInButton.isHidden = true
        }
    }
    
}



extension InitialScreenViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

