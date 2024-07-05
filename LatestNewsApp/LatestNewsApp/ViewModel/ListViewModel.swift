//
//  ListViewModel.swift
//  LatestNewsApp
//
//  Created by Mehmet Jiyan Atalay on 3.07.2024.
//

import Foundation

class ListViewModel : ObservableObject {
    @Published var news : NewsModel?
    
    let webservice = WebService()
    
    func downloadNewsList(url : URL) async {
        do {
            //let data = try await webservice.downloadNews(resource: Constants.Paths.basePath())
            let data = try await webservice.downloadNews(url: url)
            
            DispatchQueue.main.async {
                self.news = data
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
