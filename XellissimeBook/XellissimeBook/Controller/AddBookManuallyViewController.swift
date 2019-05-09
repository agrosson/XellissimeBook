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
    
    // MARK: - Properies
    /// Book to save on FireBase
    var bookToSave: Book?
    // MARK: - Outlets : UITextfield
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var isbnTextField: UITextField!
    // MARK: - Outlets : UITStackView
    @IBOutlet weak var mainSV: UIStackView!
    // MARK: - Outlets : UILabel
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    // MARK: - Outlets : UIBarButtonItem
    @IBOutlet weak var item: UIBarButtonItem!
    // MARK: - Outlets : UIButton
    @IBOutlet weak var addToDatabaseButton: UIButton!
    
    // MARK: - Actions
    @IBAction func testGoogleAPI(_ sender: UIButton) {
        let isbnFromScreen = isbnTextField.text!
        print("isbn ecran \(isbnFromScreen)")
        let api = GoogleBookAPI(isbn: isbnFromScreen)
        guard let fullUrl = api.googleBookFullUrl else {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .googleBookAPIProblemWithUrl
            return
        }
        let method = api.httpMethod
        let googleCall = NetworkManager.shared
        
        
        googleCall.getBookInfo(fullUrl: fullUrl, method: method, isbn: api.isbn, callBack: { (success, bookresult) in
            if bookresult != nil {
            
                // Fill the textfield with the data retrieved
                
                // make an alternative view pop-over and possibility to save on firebase 
                self.titleTextField.text = bookresult?.bookTitle
                self.authorTextField.text = bookresult?.bookAuthor
                
                self.bookToSave = bookresult
            }
            else {
                print("echec on lance un autre api? ")
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .googleBookDidNotFindAResult
            }
        })
 
    }
    @IBAction func myAction(_ sender: UIButton) {
        var title = titleTextField.text ?? ""
        var author = authorTextField.text ?? ""
        var isbn = isbnTextField.text ?? ""
        var userId = ""
        var uniqueBookId = ""
        if title == "" || author == "" ||  isbn == ""  {
            self.presentAlertDetails(title: "Sorry", message: "Fill in all fields please.", titleButton: "BACK")
        } else {
            title.removeFirstAndLastAndDoubleWhitespace()
            author.removeFirstAndLastAndDoubleWhitespace()
            isbn.removeFirstAndLastAndDoubleWhitespace()
            if Auth.auth().currentUser?.uid == nil {
                print("no connection")
            }
            
            if let currentUserId = Auth.auth().currentUser?.uid {
                // Assign currentUserId to userId
                userId = currentUserId
                // Set uniqueBookId
                uniqueBookId = userId+isbn
                var book = Book(title: title, author: author, isbn: isbn)
                book.bookId = uniqueBookId
                book.bookOwner = userId
                book.bookEditor = bookToSave?.bookEditor
                book.saveBook(with: book)
            }
        }
    }
    // MARK: - Actions
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        manageTextField()
        setUpPageLogIn()
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
