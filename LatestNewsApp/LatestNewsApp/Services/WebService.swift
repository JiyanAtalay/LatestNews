
import Foundation

class WebService {
    func downloadNews(url: URL) async throws -> NewsModel {
        do {
            let (data , _) = try await URLSession.shared.data(from: url)
            
            let news = try JSONDecoder().decode(NewsModel.self, from: data)
            
            return news
            
        } catch _ as DecodingError {
            throw NewsError.decodingError
        } catch {
            throw NewsError.networkError(error)
        }
    }
    
    func downloadDatabaseNews(url: URL) async throws -> DatabaseNewsModel {
        do {
            let (data , _) = try await URLSession.shared.data(from: url)
            
            let news = try JSONDecoder().decode(DatabaseNewsModel.self, from: data)
            
            return news
            
        } catch _ as DecodingError {
            throw NewsError.decodingError
        } catch {
            throw NewsError.networkError(error)
        }
    }
}

enum NewsError: Error {
    case decodingError
    case networkError(Error)
}
