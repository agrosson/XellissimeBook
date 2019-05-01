//
//  LogInViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 01/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    // MARK: - Outlets - TextFields
    @IBOutlet weak var emailLogInTextField: UITextField!
    @IBOutlet weak var passwordLogInTextField: UITextField!
    // MARK: - Outlets - Button
    
    @IBOutlet weak var logInButton: UIButton!
    // MARK: - Actions
    
    @IBAction func logInButtonIsPressed(_ sender: UIButton) {
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
