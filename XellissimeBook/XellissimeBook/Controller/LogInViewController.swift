//
//  LogInViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 01/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    // MARK: - Outlets - TextFields
    @IBOutlet weak var emailLogInTextField: UITextField!
    @IBOutlet weak var passwordLogInTextField: UITextField!
    // MARK: - Outlets - Button
    @IBOutlet weak var logInButton: UIButton!
   
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        manageTextField()
        setUpPageLogIn()
    }
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLogInTextField.text = ""
        passwordLogInTextField.text = ""
    }
    // MARK: - Actions
    @IBAction func logInButtonIsPressed(_ sender: UIButton) {
        let email = emailLogInTextField.text ?? ""
        let password = passwordLogInTextField.text ?? ""
        if password != "" && email != "" {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                guard authResult != nil, error == nil else {
                    // manage error
                    let fireBaseError = error.debugDescription
                    let fireBaseErrorMessage = getErrorMessageFromFireBase(error: fireBaseError)
                    self.presentAlertDetails(title: "Sorry", message: fireBaseErrorMessage, titleButton: "Cancel")
                    return
                }
                print("The user has successfully logged in")
                self.performSegue(withIdentifier: TextAndString.shared.segueFromLogInToHome, sender: self)
            }
        } else {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .noData
            print("Data are no completed")
        }
    }
    // MARK: - Methods
    /**
     Function that manages TextField
     */
    private func manageTextField() {
        emailLogInTextField.delegate = self
        passwordLogInTextField.delegate = self
    }
    /**
     Function that customizes login page
     */
    private func setUpPageLogIn() {
        emailLogInTextField.backgroundColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        emailLogInTextField.textColor = #colorLiteral(red: 0.5201328993, green: 0.5498541594, blue: 0.5580087304, alpha: 1)
        passwordLogInTextField.backgroundColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        passwordLogInTextField.textColor = #colorLiteral(red: 0.5201328993, green: 0.5498541594, blue: 0.5580087304, alpha: 1)
        logInButton.layer.cornerRadius = 20
        logInButton.layer.borderWidth = 3
        logInButton.layer.borderColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
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
        emailLogInTextField.resignFirstResponder()
        passwordLogInTextField.resignFirstResponder()
    }
}
    // MARK: - Extension
extension LogInViewController : UITextFieldDelegate {
    // definition of delegate functions for UITexfields
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
