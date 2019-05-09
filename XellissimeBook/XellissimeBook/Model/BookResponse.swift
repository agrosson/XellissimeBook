//
//  BookResponse.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 09/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation

struct BookResponse:Codable {
    let kind: String?
    let totalItems: Int?
    let items: [Item]?
}

struct Item:Codable {
    let kind, id, etag: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
    let accessInfo: AccessInfo?
    let searchInfo: SearchInfo?
}

struct AccessInfo:Codable {
    let country, viewability: String?
    let embeddable, publicDomain: Bool?
    let textToSpeechPermission: String?
    let epub, pdf: Epub?
    let webReaderLink: String?
    let accessViewStatus: String?
    let quoteSharingAllowed: Bool?
}

struct Epub:Codable {
    let isAvailable: Bool?
}

struct SaleInfo:Codable {
    let country, saleability: String?
    let isEbook: Bool?
}

struct SearchInfo:Codable {
    let textSnippet: String?
}

struct VolumeInfo:Codable {
    let title, subtitle: String?
    let authors: [String]?
    let publisher, publishedDate, description: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let readingModes: ReadingModes?
    let pageCount: Int?
    let printType: String?
    let categories: [String]?
    let maturityRating: String?
    let allowAnonLogging: Bool?
    let contentVersion: String?
     let imageLinks: ImageLinks?
    let panelizationSummary: PanelizationSummary?
    let language: String?
    let previewLink, infoLink: String?
    let canonicalVolumeLink: String?
}

struct IndustryIdentifier: Codable {
    let type, identifier: String?
}

struct PanelizationSummary:Codable {
    let containsEpubBubbles, containsImageBubbles: Bool?
}

struct ReadingModes:Codable {
    let text, image: Bool?
}

struct ImageLinks:Codable {
    let smallThumbnail, thumbnail: String?
}
