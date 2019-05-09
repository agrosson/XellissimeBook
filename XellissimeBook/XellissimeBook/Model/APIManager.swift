//
//  APIManager.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 09/05/2019.
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
    private var getBooKInfoFromGoogleBooks = URLSession(configuration: .default)

    // MARK: -
    init(getBooKInfoFromGoogleBooks: URLSession){
        self.getBooKInfoFromGoogleBooks = getBooKInfoFromGoogleBooks
    }
}

// MARK: - Request for Get book info
extension NetworkManager {
    func getBookInfo(fullUrl: URL, method: String, isbn: String, callBack: @escaping (Bool, Book?) -> ()) {
        var request = URLRequest(url: fullUrl)
        request.httpMethod = method
        task?.cancel()
        let task = getBooKInfoFromGoogleBooks.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callBack(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callBack(false, nil)
                    return
                }
                guard let responseJson = try? JSONDecoder().decode(BookResponse.self, from: data) else {
                    callBack(false, nil)
                    return
                }
                guard let title = responseJson.items?.first?.volumeInfo?.title else {
                    callBack(false, nil)
                    return
                }
                guard let author = responseJson.items?.first?.volumeInfo?.authors?.first else
                {
                    callBack(false, nil)
                    return
                }
                guard let editor = responseJson.items?.first?.volumeInfo?.publisher else
                {
                    callBack(false, nil)
                    return
                }
                var isbnEmpty = String()
                if (responseJson.items?.first?.volumeInfo?.industryIdentifiers!.count)! > 0 {
                    guard let isbnTemp = responseJson.items?.first?.volumeInfo?.industryIdentifiers![1].identifier     else {
                        callBack(false, nil)
                        return
                    }
                    isbnEmpty = isbnTemp
                }
                var bookTemp = Book(title:  title,
                                    author: author,
                                    isbn: isbnEmpty)
                bookTemp.bookCoverURL = "On va trouver"
                bookTemp.bookEditor = editor
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
