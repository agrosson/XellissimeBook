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
import FirebaseStorage

class AddBookManuallyViewController: UIViewController {
    
    // MARK: - Properties
    /// Book to save on FireBase
    var bookToSave: Book?
    var bookToSaveCoverImage: UIImage?
    var tempCoverReferenceWhenUploadOrDownLoad = StorageReference()
    var coverReference: StorageReference {
        return Storage.storage().reference().child("cover")
    }
    var tempURL:String?
    
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
    /**
     Action to get book information from Google Books API
     */
    @IBAction func testGoogleAPI(_ sender: UIButton) {
        // This to ensure that no data remains in the object
        bookToSave = Book(title: "", author: "", isbn: "")
        // Get the isbn from the user (typed in textfield)
        var isbnFromTextField = isbnTextField.text!
        isbnFromTextField.removeFirstAndLastAndDoubleWhitespace()
        let api = GoogleBookAPI(isbn: isbnFromTextField)
        guard let fullUrl = api.googleBookFullUrl else {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .googleBookAPIProblemWithUrl
            return
        }
        let method = api.httpMethod
        let googleCall = NetworkManager.shared
        googleCall.getBookInfo(fullUrl: fullUrl, method: method, isbn: api.isbn, callBack: { (success, bookresult) in
            if let book = bookresult  {
                // Fill the textfield with the data retrieved
                // TODO: make an alternative view pop-over and possibility to save on firebase
                // Display all the data received from API and ask the user if want to add to database
                self.titleTextField.text = book.bookTitle
                self.authorTextField.text = book.bookAuthor
                print("ici on récupère les données du livre")
                print(book.bookCoverURL as Any)
                
                self.bookToSave = book
            }
            else {
                print("echec on lance un autre api? ")
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .googleBookDidNotFindAResult
            }
        })
    }
    /**
     Action to get book information from Open Library API
     */
    @IBAction func openlibrary(_ sender: UIButton) {
        // This to ensure that no data remains in the object
        bookToSave = Book(title: "", author: "", isbn: "")
        // Get the isbn from the user (typed in textfield)
        var isbnFromTextField = isbnTextField.text!
        isbnFromTextField.removeFirstAndLastAndDoubleWhitespace()
        let api = OpenLibraryAPI(isbn: isbnFromTextField)
        guard let fullUrl = api.openlibraryFullUrl else {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .googleBookAPIProblemWithUrl
            return
        }
        let method = api.httpMethod
        let openLibraryCall = NetworkManager.shared
        openLibraryCall.getBookInfoOpenLibrary(fullUrl: fullUrl, method: method, isbn: api.isbn, callBack: { (success, bookresult) in
            if let book = bookresult  {
                // Fill the textfield with the data retrieved
                // TODO: make an alternative view pop-over and possibility to save on firebase
                // Display all the data received from API and ask the user if want to add to database
                self.titleTextField.text = book.bookTitle
                self.authorTextField.text = book.bookAuthor
                self.bookToSave = book
            }
            else {
                print("echec openlibrary on lance un autre api? ")
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .openLibraryBookDidNotFindAResult
            }
        })
        }
 
    /**
     Action to save book information in FireBase
     */
    @IBAction func myAction(_ sender: UIButton) {
        var title = titleTextField.text ?? ""
        var author = authorTextField.text ?? ""
        var isbn = isbnTextField.text ?? ""
        var userId = ""
        var uniqueBookId = ""
        if title == "" || author == "" ||  isbn == ""  {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .needAllFieldsCompleted
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
                book.bookCoverURL = bookToSave?.bookCoverURL
                // store image in Storage
                storeCoverImageInFirebaseStorage(fromBook: book)
                // change URL for book cover
              //  book.bookCoverURL = tempURL
                saveBook(with: book)
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
    /*
     
     To do :
     on prend l'url de l'image du livre
     on télécharge l'image
     on stocke l'image sur Firebase dans database books/cover
     on enregistre l'url de Firebase dans les infos du livre
     
     */
    
    
    
    /**
     Function that manages TextField
     */
    private func manageTextField(){
        titleTextField.delegate = self
        authorTextField.delegate = self
        isbnTextField.delegate = self
    }
    
    /**
     Function that manages views for textFields
     */
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
    
    private func storeCoverImageInFirebaseStorage(fromBook : Book) {
        // get url string from book
        guard let bookUrl = fromBook.bookCoverURL else {return}
        // get url from url string
        guard let url = URL(string: bookUrl) else {return}
        // get data from url
        guard let data = try? Data(contentsOf: url) else {return}
        //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        guard let dataasImage = UIImage(data: data) else {return}
        guard let imageData = dataasImage.jpegData(compressionQuality: 1) else {return}
        tempCoverReferenceWhenUploadOrDownLoad = coverReference.child(fromBook.bookId)
        let uploadTask = tempCoverReferenceWhenUploadOrDownLoad.putData(imageData, metadata: nil) { (metadata, erro) in
            print("upload is finished")
            print(metadata ?? "no metadata")
            print(erro ?? "no error")
            // To do get the reference as a string : tempCoverURLString =
        }
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "No More Progress")
        }
        uploadTask.resume()
        tempCoverReferenceWhenUploadOrDownLoad.downloadURL(completion: { (url, error) in
            if let error = error {
                print("ajout erreur url")
                print(error)
                
            } else {
                print("ajout url ici  url")
                self.tempURL = url?.path
                print(self.tempURL as Any)
            }
        })
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
