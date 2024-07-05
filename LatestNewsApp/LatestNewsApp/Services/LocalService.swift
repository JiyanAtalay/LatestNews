//
//  LocalService.swift
//  LatestNewsApp
//
//  Created by Mehmet Jiyan Atalay on 4.07.2024.
//

import Foundation

class LocalService {
    func downloadNews(resource: String) async throws -> NewsModel {
        do {
            guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
                fatalError("Resource not found")
            }
            
            let data = try Data(contentsOf: URL(filePath: path))
            
            let news = try JSONDecoder().decode(NewsModel.self, from: data)
            
            return news
        } catch _ as DecodingError {
            throw NewsError.decodingError
        } catch {
            throw NewsError.networkError(error)
        }
    }
}
