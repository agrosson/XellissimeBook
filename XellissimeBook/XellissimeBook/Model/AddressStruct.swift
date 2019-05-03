//
//  AddressStruct.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation

struct Address {
    var addressId: String // or Int automatic incremental
    var mainAddress: String?
    var complementaryAddress: String?
    var zipCode : String?
    var city: String?
    var country : String?
    
}
