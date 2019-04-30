//
//  APIKeys.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 30/04/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
/**
 Global function to get API key from APIKeys.plist
 */
func valueForAPIKey(named keyname: String) -> String {
    let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile: filePath!)
    guard let value = plist?.object(forKey: keyname) as? String else {
        return ""
    }
    return value
}
