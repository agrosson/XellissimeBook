//
//  BookStruct.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Book class
/**
 An object that stores all elements of a book
 
 Only 3 elements are required when intializing
 
 */
struct Book {
    // MARK: - Properties
    var bookId = String() // or Int automatic incremental
    var bookIsbn: String
    var bookTitle: String
    var bookAuthor: String
    var bookEditor: String?
    var bookYearOfEdition: String?
    /// URL of the cover image
    var bookCoverURL: String?
    /// Will be set when user will add a book in the list
    var bookOwner = String() // the userIosId
    var bookIsAvailable: Bool = false
    var bookDateOfLoanStart: Date?
    var bookDateOfLoanEnd: Date?
    var bookTypeString: String?
    
    var bookType: BookType = .unknown
    //  create a failable initializer
    
    // MARK: - Method init
    init(title: String, author:String, isbn: String){
        bookIsbn = isbn
        bookTitle = title
        bookAuthor = author
    }
}


enum BookType {
    case classic, youth, cartoon, historic, scienceFiction, unknown
}
