//
//  FavoriteNewsScreen.swift
//  LatestNewsApp
//
//  Created by Mehmet Jiyan Atalay on 5.07.2024.
//

import SwiftUI
import SwiftData

struct FavoriteNewsScreen: View {
    
    @Environment(\.modelContext) private var context
    @Query(sort: \DatabaseModel.newId, order: .forward) private var news : [DatabaseModel]
    
    @ObservedObject var viewModel = FavoriteNewsViewModel()
    
    @State var showNews = false
    
    var body: some View {
        NavigationStack {
            if let data = viewModel.news {
                List(data.news, id: \.id) { new in
                    VStack {
                        AsyncImage(url: URL(string: new.image)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(width: 50, height: 50)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350, height: 250)
                            case .failure(_):
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            @unknown default:
                                // Handle unknown future cases
                                Image(systemName: "questionmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        Text(removeContentBetweenAngles(from: new.title))
                        GroupBox {
                            HStack {
                                Text(new.publishDate)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                NavigationLink(destination: DetailsScreen(new: convertToNews(new))) {
                                    Text("More >")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .frame(width: 75, height: 25)
                                        .background(Color.black)
                                        .cornerRadius(6)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.white, lineWidth: 1)
                                        )
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }.padding(.horizontal, -10)
                    .toolbar(content: {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                Task {
                                    await viewModel.downloadNewsList(url: Constants.Urls.newsByIds(ids: news.map{$0.newId}))
                                }
                            }, label: {
                                Image(systemName: "arrow.clockwise")
                            })
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                showNews = true
                            }, label: {
                                Text("News")
                            })
                        }
                    })
                    .fullScreenCover(isPresented: $showNews, content: {
                        ListScreen()
                    })
            }
        }
        .task {
            await viewModel.downloadNewsList(url: Constants.Urls.newsByIds(ids: news.map{$0.newId}))
        }
    }
    
    func removeContentBetweenAngles(from input: String) -> LocalizedStringKey {
        var result = input
        while let startRange = result.range(of: "<"), let endRange = result.range(of: ">", range: startRange.upperBound..<result.endIndex) {
            result.removeSubrange(startRange.lowerBound..<endRange.upperBound)
        }
        return LocalizedStringKey(result)
    }
    
    func convertToNews(_ databaseNews: DatabaseNews) -> News {
        return News(
            id: databaseNews.id,
            title: databaseNews.title,
            text: databaseNews.text,
            summary: databaseNews.summary,
            url: databaseNews.url,
            image: databaseNews.image,
            video: databaseNews.video,
            publishDate: databaseNews.publishDate,
            author: ((databaseNews.author?.isEmpty) != nil) ? nil : databaseNews.author,
            authors: databaseNews.authors?.isEmpty ?? false ? nil : databaseNews.authors, language: Language(rawValue: databaseNews.language) ?? Language.languageTR ,
            catgory: ((databaseNews.catgory?.isEmpty) != nil) ? nil : databaseNews.catgory,
            sourceCountry: Language(rawValue: databaseNews.sourceCountry) ?? Language.tr
        )
    }
}

#Preview {
    NavigationStack {
        FavoriteNewsScreen()
    }.modelContainer(for: [DatabaseModel.self])
}
