//
//  ListOfBooksTableViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 08/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase
import FirebaseAuth

class ListOfBooksTableViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    /// StorageDownloadTask
    var download:StorageDownloadTask!
    /// Array of books : displayed in collectionView
    var collectionBooks = [Book]()
    /// Firebase reference
    var ref: DatabaseReference?
    /// Firebase var is used to identify listeners of Firebase Database events
    var databaseHandler: DatabaseHandle?
    /// Firebase reference for cover images in Firebase Storage
    var coverReference: StorageReference = Storage.storage().reference().child("cover")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarItemSetup()
        createBookListFromFirebase()
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarItemSetup()
       // createBookListFromFirebase()
        tableView.reloadData()
    }
    // MARK: - Methods
    
    private func navBarItemSetup() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped(){
        // Todo
        print("we add a book")
    }
    
    private func createBookListFromFirebase(){
        collectionBooks = [Book]()
        ref = Database.database().reference()
        // Retrieve the books and listen for change
        self.databaseHandler = self.ref?.child("books").observe(.value, with: { (snapshot) in
            var counter = 1
            // In repo "books", go to every "child"
            for mychild in snapshot.children {
                print("Book details \(counter)")
                counter += 1
                /// A FIRDataSnapshot contains data from a Firebase Database location
                guard let childTest = mychild as? DataSnapshot else {return}
                // the data contained in the DataSnapshot is a dictionary of type [String : AnyObject]
                guard let values = childTest.value as? [String: AnyObject] else {return}
                // Get all values from Dictionary
                guard   let bookId: String = values["bookId"] as? String,
                    let bookIsbn: String = values["bookIsbn"] as? String,
                    let bookAuthor: String = values["bookAuthor"] as? String,
                    var bookCoverURL: String = values["bookCover"] as? String,
                    let bookEditor: String = values["bookEditor"] as? String,
                    let bookIsAvailable: Bool = values["bookIsAvailable"] as? Bool,
                    let bookOwner: String = values["bookIsbn"] as? String,
                    let bookTitle: String = values["bookTitle"] as? String,
                    let bookTypeString: String = values["bookType"] as? String,
                    let bookYearOfEdition: String = values["bookYearOfEdition"] as? String
                    else {return}
                print("\(bookTitle) \(bookAuthor) \(bookEditor)")
                // Use the values to create a book
                var bookFromFireBase = Book(title: bookTitle, author: bookAuthor, isbn: bookIsbn)
                bookFromFireBase.bookId = bookId
                bookCoverURL.removeFirstAndLastAndDoubleWhitespace()
                // To do here : change the url if needed
                bookFromFireBase.bookCoverURL = bookCoverURL
                bookFromFireBase.bookEditor = bookEditor
                bookFromFireBase.bookIsAvailable = bookIsAvailable
                bookFromFireBase.bookOwner = bookOwner
                bookFromFireBase.bookTypeString = bookTypeString
                bookFromFireBase.bookYearOfEdition = bookYearOfEdition
                // Add the book in the collectionBook
                self.collectionBooks.append(bookFromFireBase)
                // reload the collectionView
               
            }
            self.tableView.reloadData()
        })
    }
    
}

extension ListOfBooksTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let book = self.collectionBooks[indexPath.row]
            let bookIdToRemove = book.bookId
            let refToRemove = Database.database().reference()
            refToRemove.child("books").child(bookIdToRemove).removeValue { (error, dataref) in
                if error != nil {
                    print("fail to delete book", error as Any)
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.collectionBooks.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                
            //        self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "tableListCell", for: indexPath) as? BookListTableViewCell else {return UITableViewCell()}
        let book = self.collectionBooks[indexPath.row]
        cell.configure(isbn: book.bookIsbn, title: book.bookTitle, author: book.bookAuthor, editor: book.bookEditor ?? "unknown")
            return cell
       
    }



}


