//
//  TextAndString.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 29/04/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation

/**
 This Struct enables to list all texts of the application in a single file
 */
struct TextAndString {
    static let shared = TextAndString()
    let initialWarning = "This is the initial warning of the application. Please accept all users conditions!!"
    let conditionMustBeAccepted = "You can not use the application because you have not accepted the conditions yet"
    let userEmailAlreadyUsedByAnotherUser = "This email is already used by another user.\nPlease enter another Email."
    let emailBadlyFormatted = "This is not an Email.\nPlease enter a new Email"
    let passwordIsTooShort = "Enter password with minimum 6 characters"
    let noUserRegistered = "No user registered with this Email.\nPlease sign up"
    let invalidPassword = "Invalid password"
    let noData = "Fill all fields"
    let googleBookDidNotFindAResult = "No book found by Google Books. A new search will be launch with Open Library"
    let googleBookAPIProblemWithUrl = "URL problem with Google Books API."
    let openLibraryBookDidNotFindAResult = "No book found by Google Books. A new search will be launch with another API"
    let needAllFieldsCompleted = "Fill in all fields please."
    
    // Segue
    let segueFromLogInToHome = "logInToWelcome"
    let segueToLogIn = "goToLogInScreen"
    let segueFromInitialToWelcome = "goToWelcomeScreen"
    let goToMyListOfBooksSegue = "goToMyListOfBooksSegue"
    
    
    // Cell identifier
    let myListOfBookCell = "myListOfBookCell"
}

/**
 This extension enables to remove inaccurate whitespace
 */
extension String {
    mutating func removeFirstAndLastAndDoubleWhitespace() {
        var newString = self
        repeat{
            if newString.last == " " || newString.last == "\""{
                newString = String(newString.dropLast())
            }
            if newString.first == " " || newString.first == "\""{
                newString = String(newString.dropFirst())
            }
        }
            while newString.first == " " || newString.last == " " || newString.last == "\"" || newString.first == "\""
        repeat { newString = newString.replacingOccurrences(of: "  ", with: " ")
        } while newString.contains("  ")
        self =  newString
    }
}

