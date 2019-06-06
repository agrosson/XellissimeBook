//
//  UtilitiesTests.swift
//  XellissimeBookTests
//
//  Created by ALEXANDRE GROSSON on 06/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import XCTest
@testable import XellissimeBook

class UtilitiesTests: XCTestCase {

    /*
     No test for class CustomTabBar (UIKit framework)
     */
    
    /*
     Test of getErrorMessageFromFireBase(error: String) -> String
    */
    
    func testGivenAStringWhenUseFunctionGetErrorThenExtractAErrorMessageBetweenQuotes(){
        let stringTotest = "This is an \"Expression to extract\" thank you"
        let resultToGet = "Expression to extract"
        let test = getErrorMessageFromFireBase(error: stringTotest)
        XCTAssertEqual(resultToGet, test)
    }
    
    func testGivenAStringwithOnlyOneQuoteWhenUseFunctionGetErrorThenReturnNil(){
        let stringTotest = "This is an Expression to extract\" thank you"
        //let resultToGet = "Expression to extract"
        let test = getErrorMessageFromFireBase(error: stringTotest)
        XCTAssertNil(test)
    }
    
    func testGivenAStringwithNoQuoteWhenUseFunctionGetErrorThenReturnNil(){
        let stringTotest = "This is an Expression to extract thank you"
        //let resultToGet = "Expression to extract"
        let test = getErrorMessageFromFireBase(error: stringTotest)
        XCTAssertNil(test)
    }
    func test1GivenAStringwithNoQuoteWhenUseFunctionGetErrorThenReturnNil(){
        let stringTotest = "This is an \"Expression to extract\" thank you\"n and "
        //let resultToGet = "Expression to extract"
        let test = getErrorMessageFromFireBase(error: stringTotest)
        XCTAssertNil(test)
    }
    
    
    
    
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
