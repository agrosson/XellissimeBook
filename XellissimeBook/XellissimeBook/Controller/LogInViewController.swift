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
    // MARK: - Actions
    
    @IBAction func logInButtonIsPressed(_ sender: UIButton) {
        let email = emailLogInTextField.text ?? ""
        let password = passwordLogInTextField.text ?? ""
        if password != "" && email != "" {
            // create a new user
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                guard let _ = authResult, error == nil else {
                    // manage error
                    print("ici la description de l'erreur")
                    print(error.debugDescription)
                    if error.debugDescription == "Optional(Error Domain=FIRAuthErrorDomain Code=17011 \"There is no user record corresponding to this identifier. The user may have been deleted.\" UserInfo={NSLocalizedDescription=There is no user record corresponding to this identifier. The user may have been deleted., error_name=ERROR_USER_NOT_FOUND})" {
                        Alert.shared.controller = self
                        Alert.shared.alertDisplay = .noUserRegistered
                    }
                    
                    if error.debugDescription == "Optional(Error Domain=FIRAuthErrorDomain Code=17009 \"The password is invalid or the user does not have a password.\" UserInfo={NSLocalizedDescription=The password is invalid or the user does not have a password., error_name=ERROR_WRONG_PASSWORD})" {
                        Alert.shared.controller = self
                        Alert.shared.alertDisplay = .invalidPassword
                    }
                    return
                }
            print("The user has successfully logged in")
               self.performSegue(withIdentifier: TextAndString.shared.segueFromLogInToHome, sender: self)
            }
     /*
            createUser(withEmail: email, password: password) { (authResult, error) in
                guard let _ = authResult, error == nil else {
                    
                    
                    // manage error here :
                    
                    
                    print("ici la description de l'erreur")
                    // case : The email address is already in use by another account.
                    if error.debugDescription == "Optional(Error Domain=FIRAuthErrorDomain Code=17007 \"The email address is already in use by another account.\" UserInfo={NSLocalizedDescription=The email address is already in use by another account., error_name=ERROR_EMAIL_ALREADY_IN_USE})" {
                        Alert.shared.controller = self
                        Alert.shared.alertDisplay = .userEmailAlreadyUsedByAnotherUser
                        print("Faire un message  d'erreur en disant que: The email address is already in use by another account.")
                    }
                    // case: The password must be 6 characters long or more.
                    if error.debugDescription == "Optional(Error Domain=FIRAuthErrorDomain Code=17026 \"The password must be 6 characters long or more.\" UserInfo={error_name=ERROR_WEAK_PASSWORD, NSLocalizedFailureReason=Password should be at least 6 characters, NSLocalizedDescription=The password must be 6 characters long or more.})" {
                        print("Faire un message indiquant que: The password must be 6 characters long or more.")
                        Alert.shared.controller = self
                        Alert.shared.alertDisplay = .passwordIsTooShort
                    }
                    // case : The email address is badly formatted.
                    if error.debugDescription == "Optional(Error Domain=FIRAuthErrorDomain Code=17008 \"The email address is badly formatted.\" UserInfo={NSLocalizedDescription=The email address is badly formatted., error_name=ERROR_INVALID_EMAIL})" {
                        print("Faire un message indiquant que: The email address is badly formatted.")
                        Alert.shared.controller = self
                        Alert.shared.alertDisplay = .emailBadlyFormatted
                    }
                    
                    print(error.debugDescription)
                    return
                }
                print(authResult?.description ?? "no description")
                self.performSegue(withIdentifier: "goToWelcomeScreen", sender: self)
            }
            */
            
        } else {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .noData
            print("Data are no completed")
        }
    }
        
        
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageTextField()
        setUpPageLogIn()
        
    }
    
    /**
     Function that manages TextField
     */
    private func manageTextField(){
    emailLogInTextField.delegate = self
      passwordLogInTextField.delegate = self

    }
    private func setUpPageLogIn(){
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
    
    private func gestureTapCreation(){
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTap
            ))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(mytapGestureRecognizer)
    }
    
    private func gestureswipeCreation(){
        let mySwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(myTap
            ))
        mySwipeGestureRecognizer.direction = .down
        self.view.addGestureRecognizer(mySwipeGestureRecognizer)
    }
    
    @objc private func myTap() {
        emailLogInTextField.resignFirstResponder()
        passwordLogInTextField.resignFirstResponder()
    }

}
extension LogInViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
