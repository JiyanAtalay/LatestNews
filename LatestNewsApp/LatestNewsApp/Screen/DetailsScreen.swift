//
//  DetailsScreen.swift
//  LatestNewsApp
//
//  Created by Mehmet Jiyan Atalay on 4.07.2024.
//

import SwiftUI
import SwiftData

struct DetailsScreen: View {
    
    @Environment(\.modelContext) private var context
    
    @State var new : News
    @State private var statusBool : Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    Text(new.title)
                        .font(.title2)
                    Text(removeContentBetweenAngles(from: new.summary ?? ""))
                        .padding(20)
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
                    Text(removeContentBetweenAngles(from: new.text))
                        .padding(20)
                    
                    GroupBox {
                        HStack {
                            VStack {
                                Text(new.publishDate)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(new.catgory?.capitalizingFirstLetter() ?? "")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 5)
                            }
                            VStack {
                                Text(new.author ?? "")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                Button(action: {
                                    checkNew(id: new.id)
                                    
                                }, label: {
                                    Text(statusBool ? "Delete -" : "Favorite +")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .frame(width: 100, height: 30)
                                        .background(Color.black)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.white, lineWidth: 1)
                                        )
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                })
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            searchNew(id: new.id)
        }
    }
    
    func removeContentBetweenAngles(from input: String) -> LocalizedStringKey {
        var result = input
        while let startRange = result.range(of: "<"), let endRange = result.range(of: ">", range: startRange.upperBound..<result.endIndex) {
            result.removeSubrange(startRange.lowerBound..<endRange.upperBound)
        }
        return LocalizedStringKey(result)
    }
    
    func searchNew(id: Int) {
        let descriptor = FetchDescriptor<DatabaseModel>(
            predicate: #Predicate { $0.newId ==  id}
        )
        do {
            let elements = try context.fetch(descriptor)
            
            if elements.count != 0 {
                statusBool = true
            } else {
                statusBool = false
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkNew(id: Int) {
        if statusBool {
            
            let fetchRequest = FetchDescriptor<DatabaseModel>(
                predicate: #Predicate { $0.newId == id }
            )
            
            do {
                let results = try context.fetch(fetchRequest)
                if let objectToDelete = results.first {
                    context.delete(objectToDelete)
                } else {
                    print("Nesne bulunamadı.")
                }
                statusBool = false
            } catch {
                print("Fetch error: \(error)")
            }
        } else {
            let newObject = DatabaseModel(newId: new.id)
            context.insert(newObject)
            statusBool = true
        }
        
        do {
            try context.save()
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
        
    }
}

#Preview {
    NavigationStack {
        DetailsScreen(new: News(id: 245793538, title: "ALKOLE ÖTV ZAMMI 2024: Alkol fiyatlarına ÖTV zammı geldi... 70'lik rakının fiyatı ne kadar oldu?", text: "Türkiye İstatistik Kurumu'nun 6 aylık Yurt içi ÜFE’yi yüzde 19,49 olarak açıklamasıyla birlikte akaryakıt, sigara ve alkol ürünlerinden alınan ÖTV tutarlarında bu oranda artış yapıldı.", summary: "<img align=\"right\" border=\"0\" height=\"84\" src=\"https://i.dunya.com/2/150/84/storage/files/images/2024/07/03/kapak-20-003l_cover.jpg\" style=\"border: navy 1px solid;\" width=\"150\" />Türkiye İstatistik Kurumu'nun (TÜİK), haziran ayı enflasyon verilerini açıklamasının ardından akaryakıt, sigara ve alkoldeki Özel Tüketim Vergisi (ÖTV) zammı belli oldu.", url: "https://www.dunya.com/ekonomi/alkole-otv-zammi-2024-alkol-fiyatlarina-otv-zammi-geldi-70lik-rakinin-fiyati-ne-kadar-oldu-haberi-735093", image: "https://i.dunya.com/2/714/402/storage/files/images/2024/07/03/kapak-20-003l_cover.jpg.webp", video: nil, publishDate: "2024-07-03 13:21:47", author: "Dünya Gazetesi", authors: ["Dünya Gazetesi"], language: Language.languageTR, catgory: "business", sourceCountry: Language.tr))
    }.modelContainer(for: [DatabaseModel.self])
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
