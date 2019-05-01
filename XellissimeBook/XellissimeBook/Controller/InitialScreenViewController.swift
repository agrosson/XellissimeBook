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
    // MARK: - Actions
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
    
    
    @IBAction func SignUpButtonPressed(_ sender: UIButton) {
        let userName = userNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if userName != "" && password != "" && email != "" {
            // create a new user
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
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
                
                // Here : do what yo want when user is registered
                print(authResult?.description ?? "no description")
                
                // Get the reference of the DataBase
                let databaseReference = Database.database().reference()
                // Get the id of the current user
                let userId = Auth.auth().currentUser?.uid
                // In the dataBase, child is a repo, child userId (is an repo), create a dictionnary.
                databaseReference.child("users").child(userId!).setValue(["userName" : userName])
                
                
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
         self.performSegue(withIdentifier: "goToLogInScreen", sender: self)
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPageLogIn()
        outletDisplay(shown: false)
        checkIfHasBeenAlreadyConnected(SettingsService.hasBeenAlreadyConnected)
        SettingsService.hasBeenAlreadyConnected = true
        manageTextField()
        
       
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
    /**
     Function that manages TextField
     */
    private func manageTextField(){
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
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
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
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

extension InitialScreenViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

