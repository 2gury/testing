import Foundation
import CoreData

protocol NetworkServiceProtocol: class {
    func fetchNews(completion: @escaping (Result<[News]?, Error>) -> ())
}

class NetworkService: NetworkServiceProtocol {
    func fetchNews(completion: @escaping (Result<[News]?, Error>) -> ()) {
        let catalog = CoreDataManager.shared.getNews()
        if (!catalog.isEmpty) {
            completion(.success(catalog))
        } else {
            completion(.success(catalog))
        }
    }
}
