//
//  BookStruct.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

import UIKit

struct Book {
    var bookId = String() // or Int automatic incremental
    var bookIsbn: String
    var bookTitle: String
    var bookAuthor: String
    var bookEditor: String?
    var bookYearOfEdition: String?
    var bookCover: UIImage?
    var bookOwner = String() // the userIosId
    var bookIsAvailable: Bool = false
    var bookDateOfLoanStart: Date?
    var bookDateOfLoanEnd: Date?
    var bookTypeString: String {
        switch bookType {
        case .unknown:
            return "unknown"
        case .cartoon:
            return "cartoon"
        case .classic:
            return "classic"
        case .youth:
            return "youth"
        case .historic:
            return "historic"
        case .scienceFiction:
            return "science fiction"
//        default:
//            return "unknown"
        }
    }
    var bookType: BookType = .unknown
    //  create a failable initializer
    init(title: String, author:String, isbn: String){
        bookIsbn = isbn
        bookTitle = title
        bookAuthor = author
    }
    
    func saveBook(with book: Book){
        // create a shortcut reference : type DataReference
        let databaseReference = Database.database().reference()
        let bookToSaveDictionary: [String : Any] =  ["bookId" : book.bookId,
                                                    "bookIsbn" : book.bookIsbn,
                                                    "bookTitle" : book.bookTitle,
                                                    "bookAuthor" : book.bookAuthor,
                                                    "bookEditor": book.bookEditor ?? "",
                                                    "bookYearOfEdition" : book.bookYearOfEdition ?? "",
                                                //    "bookCover" : book.bookCover as Any,
                                                    "bookOwner": book.bookOwner,
                                                    "bookIsAvailable" : book.bookIsAvailable,
                                                //     "bookDateOfLoanStart" : book.bookDateOfLoanStart as Any,
                                                //    "bookDateOfLoanEnd": book.bookDateOfLoanEnd as Any,
                                                    "bookType" : book.bookTypeString]
    
   
        // In the dataBase, child is a repo, child userId (is an repo), create a dictionnary.
        // databaseReference.child("users").child(userId!).setValue(["bookId" : text])
        databaseReference.child("books").child(book.bookId).setValue(bookToSaveDictionary)
    }
}


enum BookType {
    case classic, youth, cartoon, historic, scienceFiction, unknown
}
