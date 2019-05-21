//
//  GoodReadsAPI.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 18/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Class GoodReadsAPI
/**
 This class enables to set parameters of the API GoogleBook
 */
class GoodReadsAPI {
    // MARK: - Properties
    /// API endPoint string
    private let endPoint = "https://www.goodreads.com/search.xml"
    /// API method
    let httpMethod = "GET"
    /// API Key
    private let keyAPI = valueForAPIKey(named: "APIGoodReads")
    /// API parameters : isbn
    var isbn: String
    /// API parameters : FullURL
    var goodReadsFullUrl: URL? {
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
        let body = "key=\(keyAPI)&q=\(isbn)"
        let fullUrl = "\(endPointUrl)?\(body)"
        guard let url = URL(string: fullUrl) else { return nil }
        return url
    }
}
