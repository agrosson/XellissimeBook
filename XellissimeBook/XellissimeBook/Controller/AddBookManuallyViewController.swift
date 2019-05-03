//
//  AddBookManuallyViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddBookManuallyViewController: UIViewController {
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var isbnTextField: UITextField!
    @IBOutlet weak var mainSV: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var addToDatabaseButton: UIButton!
    
    @IBAction func myAction(_ sender: UIButton) {
        var title = titleTextField.text ?? ""
        var author = authorTextField.text ?? ""
        var isbn = isbnTextField.text ?? ""
        if title == "" || author == "" ||  isbn == ""  {
            self.presentAlertDetails(title: "Sorry", message: "Fill in all fields please.", titleButton: "BACK")
        } else {
            title.removeFirstAndLastAndDoubleWhitespace()
            author.removeFirstAndLastAndDoubleWhitespace()
            isbn.removeFirstAndLastAndDoubleWhitespace()
           /*
             If needed later ...Create a book
             let book = Book(title: title, author: author, isbn: isbn)
             */
            // Create a dictionary with the elements you want to save
            let arrayItem = ["title" :title,
                             "author" : author,
                             "isbn" : isbn]
            // create a shortcut reference : type DataReference
            let databaseReference = Database.database().reference()
            // Get the id of the current user
            if let userId = Auth.auth().currentUser?.uid {
                // create the reference of the book with userId  et Isbn
                let uniqueBookId = userId+isbn
                // In the dataBase, child is a repo, child userId (is an repo), create a dictionnary.
                // databaseReference.child("users").child(userId!).setValue(["bookId" : text])
                databaseReference.child("books").child(uniqueBookId).setValue(arrayItem)
            }
        }
    }
    
    
    // MARK: - Actions
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        manageTextField()
        setUpPageLogIn()
        // Do any additional setup after loading the view.
    }
    
    /**
     Function that manages TextField
     */
    private func manageTextField(){
        titleTextField.delegate = self
        authorTextField.delegate = self
        isbnTextField.delegate = self
    }
    private func setUpPageLogIn(){
        titleTextField.layer.cornerRadius = 5
        authorTextField.layer.cornerRadius = 5
        isbnTextField.layer.cornerRadius = 5
        addToDatabaseButton.layer.cornerRadius = 20
        
        addToDatabaseButton.layer.borderWidth = 3
        addToDatabaseButton.layer.borderColor = #colorLiteral(red: 0.5201328993, green: 0.5498541594, blue: 0.5580087304, alpha: 1)
        
        
        titleLabel.layer.masksToBounds = true
        authorLabel.layer.masksToBounds = true
        isbnLabel.layer.masksToBounds = true
        
        titleLabel.layer.cornerRadius = 5
        authorLabel.layer.cornerRadius = 5
        isbnLabel.layer.cornerRadius = 5
        
        titleLabel.textAlignment = .center
        authorLabel.textAlignment = .center
        isbnLabel.textAlignment = .center
        
        
        //        logInButton.layer.borderWidth = 3
        //        logInButton.layer.borderColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        //        signUpButton.layer.cornerRadius = 20
        
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
        titleTextField.resignFirstResponder()
        authorTextField.resignFirstResponder()
        isbnTextField.resignFirstResponder()
    }
    
    
    
}
extension  AddBookManuallyViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
