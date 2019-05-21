//
//  UserClass.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation

class User {
    var userIosId: String? // automatic incremental
    var userEmail: String
    var userName: String
    var userFirstName: String?
    var userLastName: String?
    var userPassword: String
    var userPhoneNumber: String? // check format
    var userDateOfBirth: Date? // see format
    var userAddress: String? //  reference to an Address in class Address
    init(userEmail: String, userName: String, userPassword: String) {
        self.userEmail = userEmail
        self.userName = userName
        self.userPassword = userPassword
    }
}
