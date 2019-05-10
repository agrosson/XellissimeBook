//
//  OpenLibraryAPI.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 09/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation


// MARK: - Class GoogleBookAPI
/**
 This class enables to set parameters of the API GoogleBook
 */
class OpenLibraryAPI {
    // MARK: - Properties
    /// API endPoint string
    
    // OpenLibraryAPI :
    private let endPoint = "https://openlibrary.org/api/books"
    /// API method
    let httpMethod = "GET"
    /// API parameters : isbn 
    var isbn: String
    /// API parameters : FullURL
    var openlibraryFullUrl:URL? {
        return createFullUrl()
    }
    // MARK: -
    init(isbn: String){
        self.isbn = isbn
    }
    // MARK: - Methods
    /**
     Function that creates the full URL
     - Returns: Full URL
     */
    private func createFullUrl() -> URL? {
        let endPointUrl = endPoint
        let body = "bibkeys=ISBN:\(isbn)&format=json&jscmd=data"
        let fullUrl = "\(endPointUrl)?\(body)"
        guard let url = URL(string: fullUrl) else { return nil }
        return url
    }
}
