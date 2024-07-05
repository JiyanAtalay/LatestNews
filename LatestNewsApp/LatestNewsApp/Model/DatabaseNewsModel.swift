//
//  DatabaseNewsModel.swift
//  LatestNewsApp
//
//  Created by Mehmet Jiyan Atalay on 5.07.2024.
//

import Foundation

struct DatabaseNewsModel: Codable {
    let news: [DatabaseNews]
}

// MARK: - News
struct DatabaseNews: Codable {
    let id: Int
    let title, text: String
    let summary: String?
    let url: String
    let image: String
    let video: String?
    let publishDate: String
    let author: String?
    let authors: [String]?
    let language, sourceCountry: String
    let catgory: String?

    enum CodingKeys: String, CodingKey {
        case id, title, text, summary, url, image, video
        case publishDate = "publish_date"
        case author, authors, language
        case sourceCountry = "source_country"
        case catgory
    }
}
