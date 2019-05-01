//
//  TextAndString.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 29/04/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation


struct TextAndString {
    static let shared = TextAndString()
    let initialWarning = "This is the initial warning of the application. Please accept all users conditions!!"
    let conditionMustBeAccepted = "You can not use the application because you have not accpeted the conditions yet"
    let userEmailAlreadyUsedByAnotherUser = "This email is already used by another user.\nPlease enter another Email."
    let emailBadlyFormatted = "This is not an Email.\nPlease enter a new Email"
    let passwordIsTooShort = "Enter password with minimum 6 characters"
}
