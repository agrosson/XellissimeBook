//
//  ViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 29/04/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class InitialScreenViewController: UIViewController {

    // Elements of the initial Popover View
    // MARK: - Outlets - Views
    @IBOutlet var initialPopoverView: UIView!
    @IBOutlet var noAccessPopoverView: UIView!
    // MARK: - Outlets - StackView
    @IBOutlet weak var logStackView: UIStackView!
    // MARK: - Outlets - Labels
    @IBOutlet weak var popoverLabel: UILabel!
    @IBOutlet weak var alreadyAccountLabel: UILabel!
    // MARK: - Outlets - TextFields
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    // MARK: - Outlets - Buttons
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    // MARK: - unwind Segue
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}

    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPageLogIn()
        outletDisplay(shown: false)
        checkIfHasBeenAlreadyConnected(SettingsService.hasBeenAlreadyConnected)
        SettingsService.hasBeenAlreadyConnected = true
        manageTextField()
        if Auth.auth().currentUser?.uid == nil {
            print(" You must log in ")
        } else {
            print(Auth.auth().currentUser?.uid as Any)
            print("already logged in")
        }
        if SettingsService.hasAcceptedConditions == true && Auth.auth().currentUser?.uid != nil {
             self.performSegue(withIdentifier: "goToWelcomeScreen", sender: self)
        }
    }
    // MARK: - Actions
    /**
     Action that removes the initial popoverview
     - When clicked, the user has accepted conditions and default user var SettingsService.hasAcceptedConditions is set to true
     */
    @IBAction func iAcceptButtonPressed(_ sender: UIButton) {
        SettingsService.hasAcceptedConditions = true
        self.initialPopoverView.removeFromSuperview()
        outletDisplay(shown: true)
    }
    /**
     Action that removes the initial popoverview and present warning for conditions
     
     When clicked, the user has refused conditions and default user var SettingsService.hasAcceptedConditions is set to false
     
     If refused twice, popover with non access message
     */
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
    /**
     Action that removes the warning popoverview and present warning for conditions
     
     When clicked, the user has refused conditions and new popover is presented to ask user to accept conditions
     */
    @IBAction func backButtonIsPressed(_ sender: UIButton) {
        self.noAccessPopoverView.removeFromSuperview()
        checkIfConditionsAccepted(SettingsService.hasAcceptedConditions)
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let userName = userNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if userName != "" && password != "" && email != "" {
            // create a new user
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                guard authResult != nil, error == nil else {
                    // manage error here :
                    let fireBaseError = error.debugDescription
                    let fireBaseErrorMessage = getErrorMessageFromFireBase(error: fireBaseError) ?? "No error indication given"
                    self.presentAlertDetails(title: "Sorry", message: fireBaseErrorMessage, titleButton: "Cancel")
                    print(error.debugDescription)
                    return
                }
                // Here : do what yo want when user is registered
                print(authResult?.description ?? "no description")
                // Get the reference of the DataBase
                let databaseReference = Database.database().reference()
                // Get the id of the current user
                let userId = Auth.auth().currentUser?.uid
                // In the dataBase, child is a repo, child userId (is an repo), create a dictionnary.
                databaseReference.child("users").child(userId!).setValue(["userName": userName])
                self.performSegue(withIdentifier: "goToWelcomeScreen", sender: self)
                print("Welcome \(userName), inscription réussie ✅" )
            }
        } else {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .noData
            print("Data are no completed")
        }
    }
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        print("Go to next page :-)")
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "goToWelcomeScreen", sender: self)
        } else {
            self.performSegue(withIdentifier: "goToLogInScreen", sender: self)
        }
    }
}
    // MARK: - Extension
// Here to list all functions for viewDidLoad
extension InitialScreenViewController {
    /**
     Function that checks if the user has already been connected
     - Parameter notFirst : Bool
     */
    private func checkIfHasBeenAlreadyConnected(_ notFirst: Bool) {
        // First connection
        if !notFirst {
            self.view.addSubview(initialPopoverView)
            adaptPopoverSize()
            popoverLabel.text = TextAndString.shared.initialWarning
        }
        // The user has been already connected once
        else {
            print("autre connection")
            print("warning has been already displayed")
            checkIfConditionsAccepted(SettingsService.hasAcceptedConditions)
        }
    }
    /**
     Function that checks if the user has already accepted conditions
     - Parameter accepted : Bool
     */
    private func checkIfConditionsAccepted(_ accepted: Bool) {
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
    /**
     Function that manages TextField
     */
    private func manageTextField() {
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
    /**
     Function that sets up the layout of the initial screen
     */
    private func setUpPageLogIn() {
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
        gestureTapCreation()
        gestureswipeCreation()
    }
    /**
     Function that creates a tap gesture
     */
    private func gestureTapCreation() {
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTap
            ))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(mytapGestureRecognizer)
    }
    /**
     Function that creates a swipe gesture
     */
    private func gestureswipeCreation() {
        let mySwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(myTap
            ))
        mySwipeGestureRecognizer.direction = .down
        self.view.addGestureRecognizer(mySwipeGestureRecognizer)
    }
    /**
     Function that defines a swipe and tap gesture action
     */
    @objc private func myTap() {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    /**
     Function that shows or hides outlets on the screen
     - Parameter shown : Bool
     */
    private func outletDisplay(shown: Bool) {
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
// Here to set up popover display
extension InitialScreenViewController {
    /**
     Function that sets up the size of the initial popover
     */
    private func adaptPopoverSize() {
        initialPopoverView.frame.size.height = 2 * screenHeight / 3
        initialPopoverView.bounds.size.width = 2 * screenWidth / 3
        initialPopoverView.layer.cornerRadius = popoverRoundRadius
        self.initialPopoverView.center = self.initialPopoverView.superview!.center
    }
    /**
     Function that sets up the size of the no access popover
     */
    private func adaptNoAccessPopoverSize() {
        noAccessPopoverView.frame.size.height = 2 * screenHeight/3
        noAccessPopoverView.bounds.size.width = 2 * screenWidth/3
        noAccessPopoverView.layer.cornerRadius = popoverRoundRadius
        self.noAccessPopoverView.center = self.noAccessPopoverView.superview!.center
    }
}
// MARK: - Extensions: protocol UITextFieldDelegate
extension InitialScreenViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
