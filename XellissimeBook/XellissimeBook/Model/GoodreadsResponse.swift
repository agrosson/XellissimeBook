//
//  GoodreadsResponse.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 16/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation

struct GoodreadsResponse: Codable {
    let request: GoodreadsResponse.Request?
    let search: GoodreadsResponse.Search?
    struct Request: Codable {
        let authentication: Bool?
        let key: String? // à revoir
        let method: String? // à revoir
    }
    struct Search: Codable {
        let query: String? // à revoir
        let resultsStart: Int?
        let resultsEnd: Int?
        let totalResults: Int?
        let source: String?
        let queryTimeSeconds: Double?
        let results: GoodreadsResponse.Result?
    }
    struct Result: Codable {
        let work: Work?
    }
    struct Work: Codable {
        let id, book_count, ratings_count, text_reviews_count: Int?
        let original_publication_year,original_publication_month, original_publication_day: Int?
        let average_rating: Double?
        let best_book: GoodreadsResponse.Book?
    }
    struct Book: Codable {
        let id: Int?
        let title: String?
        let author: GoodreadsResponse.Author?
        let image_url, small_image_url: String?
    }
    struct Author: Codable {
        let id: Int?
        let name: String?
    }
}
