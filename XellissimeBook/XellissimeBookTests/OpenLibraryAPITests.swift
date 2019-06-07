//
//  OpenLibraryAPITests.swift
//  XellissimeBookTests
//
//  Created by ALEXANDRE GROSSON on 07/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import XCTest
@testable import XellissimeBook

class OpenLibraryAPITests: XCTestCase {

    func testOpenLibraryAPICreateFullString() {
        
        let object = OpenLibraryAPI(isbn: "456")
        let stringToGetAsAURL = "https://openlibrary.org/api/books?bibkeys=ISBN:456&format=json&jscmd=data"
        guard let result = object.openlibraryFullUrl?.absoluteString else {return}
        XCTAssertEqual(result, stringToGetAsAURL)
        
    }
    
}
