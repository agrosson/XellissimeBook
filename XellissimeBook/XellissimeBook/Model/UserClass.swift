//
//  UserClass.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation


// MARK: - CustomTabBar class
/**
 This class describes users' attributes
 */
class User {
    /// A unique user's identifier
    let userIosId = UUID()
    /// The user's Email
    var userEmail: String
    /// The userName (nickname)
    var userName: String
    /// The user's first name
    var userFirstName: String?
    /// The user's last name
    var userLastName: String?
    /// The user's password
    var userPassword: String
    /// The user's Phone number
    var userPhoneNumber: String? // check format
    /// The user's date of birth
    var userDateOfBirth: Date? // see format
    /// The user's address reference
    var userAddress: String? //  reference to an Address in class Address
    /// Notation of the user given by community
    var userNotation: Double?
    /// init function for Users
    init(userEmail: String, userName: String, userPassword: String) {
        self.userEmail = userEmail
        self.userName = userName
        self.userPassword = userPassword
    }
}
