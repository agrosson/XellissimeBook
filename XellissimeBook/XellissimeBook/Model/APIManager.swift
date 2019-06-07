//
//  APIManager.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 09/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import UIKit

// MARK: Networking class
class NetworkManager {
    // MARK: Singleton
    static var shared = NetworkManager()
    private init() {}
    // Task creation
    // MARK: - Networking properties
    private var task: URLSessionDataTask?
    private var getBooKInfoFromGoogleBooks = URLSession(configuration: .default)
    private var getBookInfoOpenLibrary = URLSession(configuration: .default)
    private var getBookInfoGoodReads = URLSession(configuration: .default)
    // MARK: -
    init(getBooKInfoFromGoogleBooks: URLSession, getBookInfoOpenLibrary: URLSession, getBookInfoGoodReads: URLSession) {
        self.getBooKInfoFromGoogleBooks = getBooKInfoFromGoogleBooks
        self.getBookInfoOpenLibrary = getBookInfoOpenLibrary
        self.getBookInfoGoodReads = getBookInfoGoodReads
    }
}

// MARK: - Request for Get book info
extension NetworkManager {
    func getBookInfo(fullUrl: URL, method: String, isbn: String, callBack: @escaping (Bool, Book?) -> Void) {
        var request = URLRequest(url: fullUrl)
        request.httpMethod = method
        task?.cancel()
        let task = getBooKInfoFromGoogleBooks.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                // test there are some datas and there is not error
                guard let data = data, error == nil
                    else {callBack(false, nil);return}
                // test if response ok is ok (statusCode is 200)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200
                    else {callBack(false, nil);return}
                // test if data is of type BookResponse
                guard let responseJson = try? JSONDecoder().decode(BookResponse.self, from: data)
                    else {callBack(false, nil);return}
                // Test if there is a book title in responseJson
                guard let title = responseJson.items?.first?.volumeInfo?.title
                    else {callBack(false, nil);return}
                // Test if there is an author name of the book in responseJson
                guard let author = responseJson.items?.first?.volumeInfo?.authors?.first
                    else {callBack(false, nil);return}
                // Test if there is an editor for the book in responseJson
                guard let editor = responseJson.items?.first?.volumeInfo?.publisher
                    else {callBack(false, nil);return}
                var isbnEmpty = ""
                // check if there is an ISBN in the responseJson, otherwise skip the code block
                if responseJson.items?.first?.volumeInfo?.industryIdentifiers?.count ?? 0 > 0 {
                    if let tempsId = responseJson.items?.first?.volumeInfo?.industryIdentifiers {
                        for item in tempsId {
                            guard let isbnFromFile = item.identifier else {return}
                            if isbnFromFile.count == 13 {
                                isbnEmpty = isbnFromFile
                            }
                        }
                    }
                } else {callBack(false, nil);return}
                // test if isbn is not empty
                if isbn != isbnEmpty {
                    callBack(false, nil)
                    return
                }
                var coverTemp = ""
                // test there is an url for the cover image (as a string)
                if let cover = responseJson.items?.first?.volumeInfo?.imageLinks?.thumbnail {
                    coverTemp = cover
                }
                // create a Book object if all tests satisfied with the data retrieved
                var bookTemp = Book(title: title,
                                    author: author,
                                    isbn: isbnEmpty)
                bookTemp.bookCoverURL = coverTemp
                bookTemp.bookEditor = editor
                callBack(true, bookTemp)
            }
        }
        task.resume()
    }
}

extension NetworkManager {
    func getBookInfoOpenLibrary(fullUrl: URL, method: String, isbn: String, callBack: @escaping (Bool, Book?) -> Void) {
        var request = URLRequest(url: fullUrl)
        print(fullUrl)
        request.httpMethod = method
        task?.cancel()
        let task = getBookInfoOpenLibrary.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                // test there are some datas and there is not error
                guard let data = data, error == nil else {callBack(false, nil);return}
                // test if response ok is ok (statusCode is 200)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200
                    else {callBack(false, nil);return}
                 // test if data is of type [String: BookOpenLibraryResponse]
                guard let responseJson = try? JSONDecoder().decode([String: BookOpenLibraryResponse].self,
                                                                   from: data)
                    else {callBack(false, nil);return}
                // extract object BookOpenLibraryResponse from responseJson
                guard let openLibraryResponse = responseJson["ISBN:\(isbn)"] else {callBack(false, nil);return}
                // test if there is a book title
                guard let title =  openLibraryResponse.title else {callBack(false, nil);return}
                // test if there is a book author
                guard let author = openLibraryResponse.authors?.first?.name else {callBack(false, nil);return}
                // test if there is a book editor
                guard let editor = openLibraryResponse.publishers?.first?.name else {callBack(false, nil);return}
                // test if there is a book isbn
                guard let tempIsbn = openLibraryResponse.identifiers?["isbn_13"] else {callBack(false, nil);return}
                guard let firstItem = tempIsbn.first else {callBack(false, nil);return}
                // test there is an url cover as a tring
                var coverTemp = ""
                if let coverMedium = openLibraryResponse.cover?.medium {
                    coverTemp = coverMedium
                } else {
                    if let coverSmall = openLibraryResponse.cover?.small {
                        coverTemp = coverSmall
                    } else {
                        if let coverLarge = openLibraryResponse.cover?.large {
                            coverTemp = coverLarge
                        }
                    }
                }
                // create a Book object if all tests satisfied with the data retrieved
                var bookTemp = Book(title: title,
                                    author: author,
                                    isbn: firstItem)
                bookTemp.bookCoverURL = coverTemp
                bookTemp.bookEditor = editor
                callBack(true, bookTemp)
            }
        }
        task.resume()
    }
}
extension NetworkManager {
    func getBookInfoGoodReads(fullUrl: URL,
                              method: String,
                              isbn: String,
                              callBack: @escaping (Bool, Book?) -> Void) {
        var request = URLRequest(url: fullUrl)
        request.httpMethod = method
        task?.cancel()
        let task = getBookInfoGoodReads.dataTask(with: request) { (datagoodreads, response, error) in
            DispatchQueue.main.async {
                 // test there are some datas and there is not error
                guard let data = datagoodreads, error == nil else {callBack(false, nil);return}
                // test if response ok is ok (statusCode is 200)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200
                    else {callBack(false, nil);return}
                // Create an XML Accessor
                let xml = XML.parse(data)
                // Parse XML data to get all items neeeded
                guard let title =  xml["GoodreadsResponse", "search", "results",
                                       "work", "best_book", "title"].text
                    else {callBack(false, nil);return}
                guard let author = xml["GoodreadsResponse", "search", "results",
                                       "work", "best_book", "author",
                                       "name"].text
                    else {callBack(false, nil);return}
                var coverTemp = ""
                if let coverMedium =  xml["GoodreadsResponse", "search", "results",
                                          "work", "best_book", "image_url"].text {coverTemp = coverMedium} else {
                    if let coverSmall = xml["GoodreadsResponse", "search", "results",
                                            "work", "best_book", "small_image_url"].text {coverTemp = coverSmall}
                }
                // create a Book object if all tests satisfied with the data retrieved
                var bookTemp = Book(title: title, author: author, isbn: isbn)
                bookTemp.bookCoverURL = coverTemp
                bookTemp.bookEditor = "N/A"
                callBack(true, bookTemp)
            }
        }
        task.resume()
    }
}
