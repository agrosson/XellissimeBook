//
//  GoogleBookAPI.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 09/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation

import UIKit

// MARK: - Class GoogleBookAPI
/**
 This class enables to set parameters of the API GoogleBook
 */
class GoogleBookAPI {
    // MARK: - Properties
    /// API endPoint string
    private let endPoint = "https://www.googleapis.com/books/v1/volumes"
    /// API method
    let httpMethod = "GET"
    /// API Key
    private let keyAPI = valueForAPIKey(named: "APIGoogle")
    /// API parameters : isbn
    var isbn: String
    /// API parameters : FullURL
    var googleBookFullUrl:URL? {
        return createFullUrl()
    }
    // MARK: -
    init(isbn: String) {
        self.isbn = isbn
    }
    // MARK: - Methods
    /**
     Function that creates the full URL
     - Returns: Full URL
     */
    private func createFullUrl() -> URL? {
        let endPointUrl = endPoint
        let body = "q=+isbn:\(isbn)&printType=books&key=\(keyAPI)"
        let fullUrl = "\(endPointUrl)?\(body)"
        guard let url = URL(string: fullUrl) else { return nil }
        return url
    }
}
