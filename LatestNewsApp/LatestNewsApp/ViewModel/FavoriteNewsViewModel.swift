//
//  FavoriteNewsViewModel.swift
//  LatestNewsApp
//
//  Created by Mehmet Jiyan Atalay on 5.07.2024.
//

import Foundation

class FavoriteNewsViewModel : ObservableObject {
    @Published var news : DatabaseNewsModel?
    
    let webservice = WebService()
    
    func downloadNewsList(url : URL) async {
        do {
            let data = try await webservice.downloadDatabaseNews(url: url)
            
            DispatchQueue.main.async {
                self.news = data
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
