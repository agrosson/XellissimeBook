//
//  BookStruct.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseDatabase

// MARK: - Book class
/**
 An object that stores all elements of a book
 Only 3 elements are required when intializing
 */
struct Book {
    // MARK: - Properties
    var bookId = String() // Will be made with Book isbn and bookOwner
    var bookIsbn: String
    var bookTitle: String
    var bookAuthor: String
    var bookEditor: String?
    var bookYearOfEdition: String?
    /// URL of the cover image
    var bookCoverURL: String?
    /// Will be set when user will add a book in the list
    var bookOwner = String() // the unqiue userIosId
    var bookIsAvailable: Bool = false
    var bookDateOfLoanStart: Date?
    var bookDateOfLoanEnd: Date?
    var bookTypeString: String?
    var bookType: BookType = .unknown
    //  create a failable initializer
    // MARK: - Method init
    init(title: String, author: String, isbn: String) {
        bookIsbn = isbn
        bookTitle = title
        bookAuthor = author
    }
}
enum BookType {
    case classic, youth, cartoon, historic, scienceFiction, unknown
}
/**
 Function that saves the book in FireBase
 - Parameter book : book to be saved
 */
func saveBook(with book: Book) {
    
    // let storageRef = Storage.storage().reference().child("cover").child(book.bookIsbn+".jpg")
    //let newCoverUrlString = "\(String(describing: storageRef))"
    // create a shortcut reference : type DataReference
    let databaseReference = Database.database().reference()
    // the book properties have to be saved as dictionary in Firebase
    let bookToSaveDictionary: [String: Any] =  ["bookId": book.bookId,
                                                "bookIsbn": book.bookIsbn,
                                                "bookTitle": book.bookTitle,
                                                "bookAuthor": book.bookAuthor,
                                                "bookEditor": book.bookEditor ?? "N/A",
                                                "bookYearOfEdition": book.bookYearOfEdition ?? "N/A",
                                                "bookCover": book.bookCoverURL ?? "",
                                                "bookOwner": book.bookOwner,
                                                "bookIsAvailable": book.bookIsAvailable,
                                                //     "bookDateOfLoanStart" : book.bookDateOfLoanStart as Any,
        //    "bookDateOfLoanEnd": book.bookDateOfLoanEnd as Any,
        "bookType": book.bookTypeString ?? "unknown"]
    // In the dataBase, child is a repo, child userId (is an repo), create a dictionnary.
    // databaseReference.child("users").child(userId!).setValue(["bookId" : text])
    databaseReference.child("books").child(book.bookId).setValue(bookToSaveDictionary)
}
