//
//  NewsModel.swift
//  LatestNewsApp
//
//  Created by Mehmet Jiyan Atalay on 3.07.2024.
//

import Foundation

struct NewsModel: Codable {
    let offset, number, available: Int
    let news: [News]
}

// MARK: - News
struct News: Codable {
    let id: Int
    let title, text: String
    let summary: String?
    let url: String
    let image: String
    let video: String?
    let publishDate: String
    let author: String?
    let authors: [String]?
    let language: Language
    let catgory: String?
    let sourceCountry: Language

    enum CodingKeys: String, CodingKey {
        case id, title, text, summary, url, image, video
        case publishDate = "publish_date"
        case author, authors, language, catgory
        case sourceCountry = "source_country"
    }
}

enum Language: String, Codable {
    case languageTR = "TR"
    case tr = "tr"
}
