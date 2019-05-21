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
    
    @IBOutlet var popoverView: UIView!
    
    // MARK: - Outlets : UIButton
    @IBOutlet weak var addToDatabaseButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Outlets : UIButton
    @IBOutlet weak var lineOne: UIView!
    @IBOutlet weak var lineTwo: UIView!
    @IBOutlet weak var lineThree: UIView!
    @IBOutlet weak var lineFour: UIView!
    @IBOutlet weak var lineFive: UIView!
    @IBOutlet weak var lineSix: UIView!
    
    @IBOutlet weak var indicatorSearch: UIActivityIndicatorView!
    @IBOutlet weak var indicatorAdd: UIActivityIndicatorView!
    // MARK: - Properties
    /// Book to save on FireBase
    var bookToSave: Book?
    var bookToSaveCoverImage: UIImage?
    var tempCoverReferenceWhenUploadOrDownLoad = StorageReference()
    var coverReference: StorageReference {
        return Storage.storage().reference().child("cover")
    }
    var tempURL:String?
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
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
    
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var addManuallyButton: UIButton!
    @IBOutlet weak var addWithCameraButton: UIButton!
    // MARK: - Actions
    
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
            }
        }
    }
    
    
    
    @IBAction func addManuallyButtonIsPressed(_ sender: UIButton) {
        showPopover()
    }
    
    
    @IBAction func addWithCameraButtonIsPressed(_ sender: UIButton) {
    }
    
    @IBAction func backToAddMenu(segue: UIStoryboardSegue){
        
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        manageTextField()
        setUpPageLogIn()
        toggleIndicator(shown: true)
        isbnTextField.text = scannedIsbn
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if scannedIsbn != "" {
            showPopover()
            
        }
    }
    private func toggleButton(isHidden : Bool){
        addManuallyButton.isHidden = isHidden
        addWithCameraButton.isHidden = isHidden
        
    }
    
    private func showPopover(){
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
    
    private func removePopover() {
        /*
        let translation = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        popoverView.transform = translation
        UIView.animate(withDuration: 2) {
            self.popoverView.transform = translation
        }
 */
        scannedIsbn = ""
        self.popoverView.removeFromSuperview()
        toggleButton(isHidden: false)
    }

    
    private func toggleIndicator(shown: Bool) {
        indicatorAdd.isHidden = shown
        indicatorSearch.isHidden = shown
        addToDatabaseButton.isEnabled = shown
        searchButton.isEnabled = shown
    }
    
    
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
        addToDatabaseButton.layer.borderColor = #colorLiteral(red: 0.778303802, green: 0.1855825782, blue: 0.253757894, alpha: 1)
        
        titleTextField.layer.borderWidth = 2
        titleTextField.layer.borderColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        authorTextField.layer.borderWidth = 2
        authorTextField.layer.borderColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        isbnTextField.layer.borderWidth = 2
        isbnTextField.layer.borderColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        
        //titleLabel.layer.borderWidth = 2
        // titleLabel.layer.borderColor = #colorLiteral(red: 0.3848406076, green: 0.4246458709, blue: 0.4326634705, alpha: 1)
        // authorLabel.layer.borderWidth = 2
        // authorLabel.layer.borderColor = #colorLiteral(red: 0.3848406076, green: 0.4246458709, blue: 0.4326634705, alpha: 1)
        // isbnLabel.layer.borderColor = #colorLiteral(red: 0.3848406076, green: 0.4246458709, blue: 0.4326634705, alpha: 1)
        // isbnLabel.layer.borderWidth = 2
        
        titleLabel.layer.masksToBounds = true
        authorLabel.layer.masksToBounds = true
        isbnLabel.layer.masksToBounds = true
        
        titleLabel.layer.cornerRadius = 5
        authorLabel.layer.cornerRadius = 5
        isbnLabel.layer.cornerRadius = 5
        
        //    cornerRadius = 15
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
    @IBAction func testGoogleAPI(_ sender: UIButton) {
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
        googleCall.getBookInfo(fullUrl: fullUrl, method: method, isbn: api.isbn, callBack: { (success, bookresult) in
            if let book = bookresult  {
                // Fill the textfield with the data retrieved
                // TODO: make an alternative view pop-over and possibility to save on firebase
                // Display all the data received from API and ask the user if want to add to database
                self.titleTextField.text = book.bookTitle
                self.authorTextField.text = book.bookAuthor
                print("ici on récupère les données du livre")
                
                self.bookToSave = book
                self.toggleIndicator(shown: true)
            }
            else {
                print("Failure : try openLibrary")
                self.openLibraryCall()
                
            }
        })
    }
    /**
     Action to get book information from Open Library API
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
        openLibraryCall.getBookInfoOpenLibrary(fullUrl: fullUrl, method: method, isbn: api.isbn, callBack: { (success, bookresult) in
            if let book = bookresult  {
                // Fill the textfield with the data retrieved
                // TODO: make an alternative view pop-over and possibility to save on firebase
                // Display all the data received from API and ask the user if want to add to database
                self.titleTextField.text = book.bookTitle
                self.authorTextField.text = book.bookAuthor
                self.bookToSave = book
                self.toggleIndicator(shown: true)
            }
            else {
                print("Failure : try GoodREads")
                self.goodReadsCall()
            }
        })
    }
    
    
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
        goodReadsCall.getBookInfoGoodReads(fullUrl: fullUrl, method: method, isbn: api.isbn, callBack: { (success, bookresult) in
            if let book = bookresult  {
                // Fill the textfield with the data retrieved
                // TODO: make an alternative view pop-over and possibility to save on firebase
                // Display all the data received from API and ask the user if want to add to database
                self.titleTextField.text = book.bookTitle
                self.authorTextField.text = book.bookAuthor
                self.bookToSave = book
                self.toggleIndicator(shown: true)
            }
            else {
                self.toggleIndicator(shown: true)
                print("Failure : the book has not been found in our databases")
               // Alert.shared.controller = self
               // Alert.shared.alertDisplay = .bookDidNotFindAResult
                let actionSheet = UIAlertController(title: "Sorry", message: "No book found in databases", preferredStyle: .alert)
                
                actionSheet.addAction(UIAlertAction(title: "Add Manually", style: .default, handler: { (action: UIAlertAction) in
                    
                    
                    self.dismiss(animated: true)
                }))
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
                    self.removePopover()
                    self.dismiss(animated: true)
                }))
                
                self.present(actionSheet, animated: true, completion : nil)
                
            }
        })
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
        // create a UIImage from the data
        guard let dataasImage = UIImage(data: data) else {return}
        // create an data in jpg format from a UIImage
        guard let imageData = dataasImage.jpegData(compressionQuality: 1) else {return}
        // Create a Storage reference with the bookId
        tempCoverReferenceWhenUploadOrDownLoad = coverReference.child("\(fromBook.bookIsbn).jpg")
        print("17 mai :  test pour reference \(tempCoverReferenceWhenUploadOrDownLoad)")
        // create a tast to put (send) the data in the Firebase storage at storage reference
        let uploadTask = tempCoverReferenceWhenUploadOrDownLoad.putData(imageData, metadata: nil) { (metadata, erro) in
            print("upload is finished")
            print(metadata ?? "no metadata")
            print(erro ?? "no error")
        }
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "No More Progress")
        }
        uploadTask.resume()
        print("Text printed if download is done")
    }

    
}
extension  AddMenuViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



