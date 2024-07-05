//
//  ContentView.swift
//  LatestNewsApp
//
//  Created by Mehmet Jiyan Atalay on 3.07.2024.
//

import SwiftUI

struct ListScreen: View {
    
    @ObservedObject var viewModel = ListViewModel()
    
    @State private var showFavorite = false
    
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
                                
                                NavigationLink(destination: DetailsScreen(new: new)) {
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
                }
                .padding(.horizontal, -10)
                .navigationTitle(Text("News"))
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            Task {
                                await viewModel.downloadNewsList(url: Constants.Urls.newsByNumber(number: 10))
                            }
                        }, label: {
                            Image(systemName: "arrow.clockwise")
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            showFavorite = true
                        }, label: {
                            Text("Favorites")
                        })
                    }
                })
                .fullScreenCover(isPresented: $showFavorite, content: {
                    FavoriteNewsScreen()
                })
            }
        }
        .task{
            await viewModel.downloadNewsList(url: Constants.Urls.newsByNumber(number: 10))
        }
    }
    
    func removeContentBetweenAngles(from input: String) -> LocalizedStringKey {
        var result = input
        while let startRange = result.range(of: "<"), let endRange = result.range(of: ">", range: startRange.upperBound..<result.endIndex) {
            result.removeSubrange(startRange.lowerBound..<endRange.upperBound)
        }
        return LocalizedStringKey(result)
    }
}

#Preview {
    ListScreen()
}
