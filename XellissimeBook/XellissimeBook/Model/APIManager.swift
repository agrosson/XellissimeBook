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
    init(getBooKInfoFromGoogleBooks: URLSession, getBookInfoOpenLibrary : URLSession, getBookInfoGoodReads : URLSession){
        self.getBooKInfoFromGoogleBooks = getBooKInfoFromGoogleBooks
        self.getBookInfoOpenLibrary = getBookInfoOpenLibrary
        self.getBookInfoGoodReads = getBookInfoGoodReads
    }
}

// MARK: - Request for Get book info
extension NetworkManager {
    func getBookInfo(fullUrl: URL, method: String, isbn: String, callBack: @escaping (Bool, Book?) -> ()) {
         print("on passe ici  A1")
        var request = URLRequest(url: fullUrl)
        request.httpMethod = method
        task?.cancel()
        let task = getBooKInfoFromGoogleBooks.dataTask(with: request) { (data, response, error) in
            print("on passe ici  A2")
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("erreur A1")
                    callBack(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                     print("erreur A2")
                    callBack(false, nil)
                    return
                }
                guard let responseJson = try? JSONDecoder().decode(BookResponse.self, from: data) else {
                     print("erreur A3")
                    callBack(false, nil)
                    return
                }
                guard let title = responseJson.items?.first?.volumeInfo?.title else {
                     print("erreur A4")
                    callBack(false, nil)
                    return
                }
                guard let author = responseJson.items?.first?.volumeInfo?.authors?.first else
                {   print("erreur A5")
                    callBack(false, nil)
                    return
                }
                guard let editor = responseJson.items?.first?.volumeInfo?.publisher else
                {    print("erreur A6")
                    callBack(false, nil)
                    return
                }
                var isbnEmpty = ""
                if responseJson.items?.first?.volumeInfo?.industryIdentifiers?.count ?? 0 > 0 {
                     print("on est là 1")
                    if let tempsId = responseJson.items?.first?.volumeInfo?.industryIdentifiers {
                        for item in tempsId {
                            print("on est là 2")
                            
                            guard let isbnFromFile = item.identifier else {return}
                            if isbnFromFile.count == 13 {
                                print("on est là 3")
                                isbnEmpty = isbnFromFile
                            }
                        }
                    }
                   
                } else {
                     print("erreur A7")
                    callBack(false, nil)
                    return
                }
                if isbn != isbnEmpty {
                     print("erreur A8")
                    callBack(false, nil)
                    return
                }
                var coverTemp = ""
                if let cover = responseJson.items?.first?.volumeInfo?.imageLinks?.thumbnail {
                    coverTemp = cover
                }
                
                  print("on est là 4")
                var bookTemp = Book(title:  title,
                                    author: author,
                                    isbn: isbnEmpty)
                bookTemp.bookCoverURL = coverTemp
                print("coverTmp = \(coverTemp)")
                bookTemp.bookEditor = editor
                callBack(true, bookTemp)
            }
        }
        task.resume()
    }
}

extension NetworkManager {
    func getBookInfoOpenLibrary(fullUrl: URL, method: String, isbn: String, callBack: @escaping (Bool, Book?) -> ()) {
        print("on passe ici  OPEN1")
        var request = URLRequest(url: fullUrl)
        print(fullUrl)
        request.httpMethod = method
        task?.cancel()
        let task = getBookInfoOpenLibrary.dataTask(with: request) { (data, response, error) in
            print("on passe ici  OPEN2")
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("erreur OPEN 1")
                    callBack(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("erreur OPEN 2")
                    callBack(false, nil)
                    return
                }
                guard let responseJson = try? JSONDecoder().decode([String : BookOpenLibraryResponse].self, from: data)
                    else {
                    print("erreur OPEN 3")
                    callBack(false, nil)
                    return
                }
                print("on est dans le decoder")
                print("ISBN:\(isbn)")
                guard let openLibraryResponse = responseJson["ISBN:\(isbn)"] else {
                    print("ça plante ici ")
                    callBack(false, nil)
                    return
                }
                guard let title =  openLibraryResponse.title else {
                     print("erreur OPEN 4")
                    callBack(false, nil)
                    return
                }
                guard let author = openLibraryResponse.authors?.first?.name else
                { print("erreur OPEN 5")
                    callBack(false, nil)
                    return
                }
                guard let editor = openLibraryResponse.publishers?.first?.name else
                { print("erreur OPEN 6")
                    callBack(false, nil)
                    return
                }
               
                guard let tempIsbn = openLibraryResponse.identifiers?["isbn_13"] else {
                     print("erreur OPEN 7")
                    callBack(false, nil)
                    return
                }
                guard let firstItem = tempIsbn.first else {
                     print("erreur OPEN 8")
                    callBack(false, nil)
                    return
                }
                var coverTemp = ""
                if let coverMedium = openLibraryResponse.cover?.medium {
                    coverTemp = coverMedium
                     print("on passe ici  OPEN3")
                } else {
                    if let coverSmall = openLibraryResponse.cover?.small {
                        coverTemp = coverSmall
                         print("on passe ici  OPEN4")
                    } else {
                        if let coverLarge = openLibraryResponse.cover?.large {
                            coverTemp = coverLarge
                        }
                    }
                }
                var bookTemp = Book(title:  title,
                                    author: author,
                                    isbn: firstItem)
                bookTemp.bookCoverURL = coverTemp
                bookTemp.bookEditor = editor
                print("on passe ici  OPEn5")
                callBack(true, bookTemp)
             
            }
        }
        task.resume()
    }
}

extension NetworkManager {
    func getBookInfoGoodReads(fullUrl: URL, method: String, isbn: String, callBack: @escaping (Bool, Book?) -> ()) {
        print("on passe ici chez GoodReads")
        var request = URLRequest(url: fullUrl)
        print(fullUrl)
        request.httpMethod = method
        task?.cancel()
        let task = getBookInfoGoodReads.dataTask(with: request) { (datagoodreads, response, error) in
             print("on passe ici chez GoodReads partie 2")
            DispatchQueue.main.async {
                guard let data = datagoodreads, error == nil else {
                   print("on passe ici chez GoodReads partie 3")
                    callBack(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                     print("on passe ici chez GoodReads partie 4")
                    callBack(false, nil)
                    return
                }
                
                // Use XLM Parser
                
                // parse xml document
                let xml = XML.parse(data)
                print(xml)
                
                print("on est dans le decoder de GoodREads")
                print("ISBN:\(isbn)")
 
                guard let title =  xml["GoodreadsResponse", "search", "results", "work", "best_book", "title"].text else {
                    print("erreur good reads 4")
                    callBack(false, nil)
                    return
                }
                guard let author = xml["GoodreadsResponse", "search", "results", "work", "best_book", "author","name"].text else
                { print("erreur good reads 5")
                    callBack(false, nil)
                    return
                }

                
                var coverTemp = ""
                if let coverMedium =  xml["GoodreadsResponse", "search", "results", "work", "best_book", "image_url"].text {
                    coverTemp = coverMedium
                    print("on passe ici  good reads 6")
                } else {
                    if let coverSmall = xml["GoodreadsResponse", "search", "results", "work", "best_book", "small_image_url"].text {
                        coverTemp = coverSmall
                        print("on passe ici  good reads 7")
                    }
                }
                var bookTemp = Book(title:  title,
                                    author: author,
                                    isbn: isbn)
                bookTemp.bookCoverURL = coverTemp
                bookTemp.bookEditor = "N/A"
                print("on passe ici  goooooooooooooooood ")
                callBack(true, bookTemp)
            }
        }
        task.resume()
    }
}






/*
 //
 //  APIManager.swift
 //  XellissimeTravel
 //
 //  Created by ALEXANDRE GROSSON on 27/03/2019.
 //  Copyright © 2019 GROSSON. All rights reserved.
 //
 
 import Foundation
 import UIKit
 
 // MARK: Networking class
 class NetworkManager {
 // MARK: Singleton
 static var shared = NetworkManager()
 private init() {}
 // Task creation
 // MARK: - Networking properties
 private var task: URLSessionDataTask?
 private var changeSession = URLSession(configuration: .default)
 private var translateSession = URLSession(configuration: .default)
 private var weatherSession = URLSession(configuration: .default)
 // MARK: -
 init(changeSession: URLSession, translateSession: URLSession, weatherSession: URLSession){
 self.changeSession = changeSession
 self.translateSession = translateSession
 self.weatherSession = weatherSession
 }
 }
 // MARK: - Request for FX
 extension NetworkManager {
 func getChange(fullUrl: URL, method: String, ToCurrency: String, callBack: @escaping (Bool, Float?) -> ()) {
 var request = URLRequest(url: fullUrl)
 request.httpMethod = method
 task?.cancel()
 let task = changeSession.dataTask(with: request) { (data, response, error) in
 DispatchQueue.main.async {
 guard let data = data, error == nil else {
 callBack(false, nil)
 return
 }
 guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
 callBack(false, nil)
 return
 }
 guard let responseJson = try? JSONDecoder().decode(ExchangeAnswer.self, from: data),
 let changeResult = responseJson.rates
 else {
 callBack(false, nil)
 return
 }
 let test = changeResult[ToCurrency]
 callBack(true, test)
 }
 }
 task.resume()
 }
 }
 // MARK: - Request for Translation
 extension NetworkManager {
 func translate(fullUrl: URL, method: String, body: String, callBack: @escaping (Bool, String?) -> ()) {
 var request = URLRequest(url: fullUrl)
 print(fullUrl)
 request.httpMethod = method
 print(body)
 task?.cancel()
 let task = translateSession.dataTask(with: request) { (data, response, error) in
 DispatchQueue.main.async {
 guard let data = data, error == nil else {
 print(error as Any)
 callBack(false, nil)
 return
 }
 guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
 callBack(false, nil)
 return
 }
 guard let responseJson = try? JSONDecoder().decode([String:DataClass].self, from: data),
 let translationResultData = responseJson["data"]
 else {
 callBack(false, nil)
 return
 }
 
 guard let translation = translationResultData.translations else {
 callBack(false, nil)
 return
 }
 
 if translation.count > 0 {
 callBack(true, translation[0].translatedText)
 } else {
 callBack(false, nil)
 return
 }
 }
 }
 task.resume()
 }
 }
 // MARK: - Request for weather
 extension NetworkManager {
 func getWeather(fullUrl : URL,method : String,body: String, dayArray: [Int], callBack : @escaping (Bool,[WeatherResponse]?) -> ()) {
 var request = URLRequest(url: fullUrl)
 request.httpMethod = method
 task?.cancel()
 let task = weatherSession.dataTask(with: request) { (data, response, error) in
 DispatchQueue.main.async {
 guard let data = data, error == nil else {
 print(error as Any)
 callBack(false, nil)
 return
 }
 guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
 callBack(false,nil)
 return
 }
 guard let responseJson = try? JSONDecoder().decode(WeatherConditions.self, from: data)
 else {
 callBack(false, nil)
 return
 }
 var testArrayResponse = [WeatherResponse]()
 for  iDay in dayArray {
 let weatherResponse = WeatherResponse(temp: (responseJson.list![iDay].main?.temp)!,
 tempMin: (responseJson.list![iDay].main?.tempMin)!,
 tempMax: (responseJson.list![iDay].main?.tempMax)!,
 pressure: (responseJson.list![iDay].main?.pressure)!,
 humidity: (responseJson.list![iDay].main?.humidity)!,
 iconString: (responseJson.list![iDay].weather![0].icon)!,
 windSpeed: (responseJson.list![iDay].wind?.speed)!,
 date: (responseJson.list![iDay].dtTxt)!
 )
 testArrayResponse.append(weatherResponse)
 }
 callBack(true, testArrayResponse)
 }
 }
 task.resume()
 }
 }

 */
