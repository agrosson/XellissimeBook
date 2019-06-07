//
//  GoogleBookApiTests.swift
//  XellissimeBookTests
//
//  Created by ALEXANDRE GROSSON on 07/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import XCTest
@testable import XellissimeBook

class GoogleBookApiTests: XCTestCase {
    
    // Test creation of an GoogleBookAPI object
    func testInitGoogleBookAPI() {
        let isbn = "123456789"
        let object = GoogleBookAPI(isbn: isbn)
        XCTAssertNotNil(object)
    }
    
    // Test creation of an GoogleBookAPI url
    func testAGoogleBookAPIUrlCreationOK() {
        let object = GoogleBookAPI(isbn: "123")
        let apikey = valueForAPIKey(named: "APIGoogle")
        let stringToGetAsAURL = "https://www.googleapis.com/books/v1/volumes?q=+isbn:123&printType=books&key=\(apikey)"
        guard let result = object.googleBookFullUrl?.absoluteString else {return}
        XCTAssertEqual(result, stringToGetAsAURL)
    }
}

