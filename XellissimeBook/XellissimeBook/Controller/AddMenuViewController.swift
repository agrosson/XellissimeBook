//
//  AddMenuViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class AddMenuViewController: UIViewController {
    
    // MARK: - Outlets : UIView
    @IBOutlet var popoverView: UIView!
    @IBOutlet weak var lineOne: UIView!
    @IBOutlet weak var lineTwo: UIView!
    @IBOutlet weak var lineThree: UIView!
    @IBOutlet weak var lineFour: UIView!
    @IBOutlet weak var lineFive: UIView!
    @IBOutlet weak var lineSix: UIView!
    // MARK: - Outlets : UIButton
    @IBOutlet weak var addToDatabaseButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var addManuallyButton: UIButton!
    @IBOutlet weak var addWithCameraButton: UIButton!
    // MARK: - Outlets : UIActivityIndicatorView
    @IBOutlet weak var indicatorSearch: UIActivityIndicatorView!
    @IBOutlet weak var indicatorAdd: UIActivityIndicatorView!
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
    // MARK: - Properties
    /// Book to save on FireBase
    var bookToSave: Book?
    /// Cover of Book to saveon FireBase
    var bookToSaveCoverImage: UIImage?
    /// Temporary StorageReference to track StorageReference
    var tempCoverReferenceWhenUploadOrDownLoad = StorageReference()
    /// StorageReference shortcut for cover
    var coverReference: StorageReference {
        return Storage.storage().reference().child("cover")
    }
    /// Temporary url as string
    var tempURL: URL?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        manageTextField()
        setUpPageLogIn()
        toggleIndicator(shown: true)
        isbnTextField.text = scannedIsbn
    }
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if scannedIsbn != "" {
            showPopover()
        }
    }
    // MARK: - Actions
    /**
     Action to save book information in FireBase
     */
    @IBAction func saveBookInDatabase(_ sender: UIButton) {
        var title = titleTextField.text ?? ""
        var author = authorTextField.text ?? ""
        var isbn = isbnTextField.text ?? ""
        var userId = ""
        var uniqueBookId = ""
        if title == "" || author == "" ||  isbn == "" {
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
              //  book.bookCoverURL = tempURL?.absoluteString
                print("la nouvelle url est : \(String(describing: book.bookCoverURL))")
                /* This block is eventually here to change URLCOVER in Firebase : Todo if needed
                 // change URL for book cover
                 let referenceToTransformInURLString = "\(coverReference.child(book.bookId)).jpg"
                 let one = referenceToTransformInURLString.fullPath
                 print("ceci est le full path \(one)")
                 book.bookCoverURL = referenceToTransformInURLString
                 book.bookCoverURL = tempURL
                 */
                // this function is defined in Utilities
                saveBook(with: book)
                scannedIsbn = ""
            }
        }
    }
    /**
     Action to search a book on GoogleBooks database
     If no book found, search on OpenLibrary then on Goodreads
     */
    @IBAction func searchCallOnGoogleBooksDatabase(_ sender: UIButton) {
        googleBookCall()
    }
    /**
     Action to show popoverView to enable the user to search and/or add/save books in his list of books
     */
    @IBAction func addManuallyButtonIsPressed(_ sender: UIButton) {
        showPopover()
    }
    @IBAction func addWithCameraButtonIsPressed(_ sender: UIButton) {
    }
    @IBAction func backToAddMenu(segue: UIStoryboardSegue) {
    }
    // MARK: - Methods
    /**
     Function that shows or hides buttons
      - Parameter isHidden: Bool
     */
    private func toggleButton(isHidden: Bool) {
        addManuallyButton.isHidden = isHidden
        addWithCameraButton.isHidden = isHidden
    }
    /**
     Function that shows popover
     */
    private func showPopover() {
        popoverView.center = CGPoint(x: view.frame.width/2,
                                     y: view.frame.height/2)
        self.view.addSubview(popoverView)
        // Get height of navBar + status bar height
        // let heightNavBar = self.navigationController?.navigationBar.bounds.height
        //   let heightBarFrame = UIApplication.shared.statusBarFrame.height
        //  if let height = heightNavBar{
        // if want to have on top
        // popoverView.frame.height/2)+height+heightBarFrame+2)
        toggleButton(isHidden: true)
        isbnTextField.text = scannedIsbn
    }
    /**
     Function that removes popover from superview
     */
    private func removePopover() {
        scannedIsbn = ""
        self.popoverView.removeFromSuperview()
        toggleButton(isHidden: false)
    }
    /**
     Function that shows or hides activity indicators
     - Parameter shown: Bool
     */
    private func toggleIndicator(shown: Bool) {
        indicatorAdd.isHidden = shown
        indicatorSearch.isHidden = shown
        addToDatabaseButton.isEnabled = shown
        searchButton.isEnabled = shown
    }
    /**
     Function that manages TextField
     */
    private func manageTextField() {
        titleTextField.delegate = self
        authorTextField.delegate = self
        isbnTextField.delegate = self
    }
    /**
     Function that manages views for textFields
     */
    private func setUpPageLogIn() {
        titleTextField.layer.cornerRadius = 5
        authorTextField.layer.cornerRadius = 5
        isbnTextField.layer.cornerRadius = 5
        addToDatabaseButton.layer.cornerRadius = 20
        addToDatabaseButton.layer.borderWidth = 3
        addToDatabaseButton.layer.borderColor = #colorLiteral(red: 0.778303802, green: 0.1855825782, blue: 0.253757894, alpha: 1)
        titleTextField.layer.borderWidth = 2
        titleTextField.layer.borderColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        authorTextField.layer.borderWidth = 2
        authorTextField.layer.borderColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        isbnTextField.layer.borderWidth = 2
        isbnTextField.layer.borderColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        titleLabel.layer.masksToBounds = true
        authorLabel.layer.masksToBounds = true
        isbnLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 5
        authorLabel.layer.cornerRadius = 5
        isbnLabel.layer.cornerRadius = 5
        lineOne.layer.cornerRadius = 5
        lineTwo.layer.cornerRadius = 5
        lineThree.layer.cornerRadius = 5
        lineFour.layer.cornerRadius = 5
        lineFive.layer.cornerRadius = 5
        lineSix.layer.cornerRadius = 5
        titleLabel.textAlignment = .center
        authorLabel.textAlignment = .center
        isbnLabel.textAlignment = .center
        gestureTapCreation()
        gestureswipeCreation()
    }
    /**
     Function to get book information from GoogleBooks API
     */
    private func googleBookCall() {
        toggleIndicator(shown: false)
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
        googleCall.getBookInfo(fullUrl: fullUrl, method: method, isbn: api.isbn, callBack: { (_, bookresult) in
            if let book = bookresult {
                self.titleTextField.text = book.bookTitle
                self.authorTextField.text = book.bookAuthor
                print("ici on récupère les données du livre")
                self.bookToSave = book
                self.toggleIndicator(shown: true)
            } else {
                print("Failure : try openLibrary")
                self.openLibraryCall()
            }
        })
    }
    /**
     Function to get book information from Open Library API
     */
    private func openLibraryCall() {
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
        openLibraryCall.getBookInfoOpenLibrary(fullUrl: fullUrl,
                                               method: method,
                                               isbn: api.isbn,
                                               callBack: { (_, bookresult) in
            if let book = bookresult {
                self.titleTextField.text = book.bookTitle
                self.authorTextField.text = book.bookAuthor
                self.bookToSave = book
                self.toggleIndicator(shown: true)
            } else {
                print("Failure : try GoodREads")
                self.goodReadsCall()
            }
        })
    }
    /**
     Function to get book information from GoodReads API
     */
    private func goodReadsCall() {
        // This to ensure that no data remains in the object
        bookToSave = Book(title: "", author: "", isbn: "")
        // Get the isbn from the user (typed in textfield)
        var isbnFromTextField = isbnTextField.text!
        isbnFromTextField.removeFirstAndLastAndDoubleWhitespace()
        let api = GoodReadsAPI(isbn: isbnFromTextField)
        guard  let fullUrl = api.goodReadsFullUrl
            else {
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .googleBookAPIProblemWithUrl
                return
        }
        let method = api.httpMethod
        let goodReadsCall = NetworkManager.shared
        goodReadsCall.getBookInfoGoodReads(fullUrl: fullUrl,
                                           method: method,
                                           isbn: api.isbn,
                                           callBack: { (_, bookresult) in
            if let book = bookresult {
                self.titleTextField.text = book.bookTitle
                self.authorTextField.text = book.bookAuthor
                self.bookToSave = book
                self.toggleIndicator(shown: true)
            } else {
                self.toggleIndicator(shown: true)
                print("Failure : the book has not been found in our databases")
               // Alert.shared.controller = self
               // Alert.shared.alertDisplay = .bookDidNotFindAResult
                let actionSheet = UIAlertController(title: "Sorry",
                                                    message: "No book found in databases",
                                                    preferredStyle: .alert)
                actionSheet.addAction(UIAlertAction(title: "Add Manually",
                                                    style: .default,
                                                    handler: { (_: UIAlertAction) in
                    self.dismiss(animated: true)
                }))
                actionSheet.addAction(UIAlertAction(title: "Cancel",
                                                    style: .default,
                                                    handler: { (_: UIAlertAction) in
                    self.removePopover()
                    self.dismiss(animated: true)
                }))
                self.present(actionSheet, animated: true, completion: nil)
            }
        })
    }
    /**
     Function that creates a tap Gesture Recognizer
     */
    private func gestureTapCreation() {
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTap
            ))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(mytapGestureRecognizer)
    }
    /**
     Function that creates a Swipe Gesture Recognizer
     */
    private func gestureswipeCreation() {
        let mySwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(myTap
            ))
        mySwipeGestureRecognizer.direction = .down
        self.view.addGestureRecognizer(mySwipeGestureRecognizer)
    }
    /**
     Action for tap and Swipe Gesture Recognizer
     */
    @objc private func myTap() {
        titleTextField.resignFirstResponder()
        authorTextField.resignFirstResponder()
        isbnTextField.resignFirstResponder()
    }

}
extension  AddMenuViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
/*
 Pas besoin d'utiliser les gs:// tu peux utiliser la première méthode avec les child en suivant ces étapes:
 let storageRef = Storage.storage().reference().child("....").child("")
 
 1) uploader l'image: storageRef.putData(imageData, metadata: nil) { (metadata, erro) in ...............
 2) récupérer l'url de l'image toujours dans la même closure:
 storageRef.downloadURL(completion: { (url, error) in      (c'est l'url qui nous intéresse ici)
 3) stocker l'url dans la database avec les autres infos du livre (auteur, année etc ...) pour pouvoir les récupérer plus tard.
 */
