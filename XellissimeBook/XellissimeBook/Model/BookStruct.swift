//
//  BookStruct.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

struct Book {
    var bookId: String? // or Int automatic incremental
    var bookIsbn: String
    var bookTitle: String
    var bookAuthor: String
    var bookEditor: String?
    var bookYearOfEdition: String?
    var bookCover: UIImage?
    var bookOwner: String? // the userIosId
    var bookIsAvailable: Bool = false
    var bookDateOfLoanStart: Date?
    var bookDateOfLoanEnd: Date?
    var bookType: BookType = .unknown
    
    init(title: String, author:String, isbn: String){
        bookIsbn = isbn
        bookTitle = title
        bookAuthor = author
    }
}

enum BookType {
    case unknown, classic, youth, cartoon, historic, scienceFiction
}
