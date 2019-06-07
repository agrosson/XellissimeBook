//
//  GoodReadsAPITests.swift
//  XellissimeBookTests
//
//  Created by ALEXANDRE GROSSON on 07/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import XCTest
@testable import XellissimeBook

class GoodReadsAPITests: XCTestCase {
    // Test creation of an GoodReadsAPI url
    func testGoodReadsAPIcreateFullUrl() {
            let object = GoodReadsAPI(isbn: "123")
            let apikey = valueForAPIKey(named: "APIGoodReads")
            let stringToGetAsAURL = "https://www.goodreads.com/search.xml?key=\(apikey)&q=123"
            guard let result = object.goodReadsFullUrl?.absoluteString else {return}
            XCTAssertEqual(result, stringToGetAsAURL)
    }
}

