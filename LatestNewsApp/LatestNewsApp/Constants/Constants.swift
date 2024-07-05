//
//  Constants.swift
//  LatestNewsApp
//
//  Created by Mehmet Jiyan Atalay on 3.07.2024.
//

import Foundation

struct Constants {
    struct Urls {
        static func newsByNumber(number: Int) -> URL {
            return URL(string: "https://api.worldnewsapi.com/search-news?source-countries=tr&language=tr&number=\(number)&sort=publish-time&sort-direction=DESC&api-key=?")!
        }
        
        static func newsByIds(ids: [Int]) -> URL {
            let idsString = ids.map { String($0) }.joined(separator: ",")

            return URL(string: "https://api.worldnewsapi.com/retrieve-news?ids=\(idsString)&api-key=?")!
        }
    }
    
    struct Paths {
        static func basePath() -> String{
            return "deneme"
        }
    }
}
