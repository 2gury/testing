import Foundation
import CoreData

protocol NewsAccessProtocol {
    func getNews() -> [News]
}

extension CoreDataManager: NewsAccessProtocol {
    func getNews() -> [News] {
        let context = self.viewContext
        let fetchRequest = NSFetchRequest<NewEntity>(entityName: "NewEntity")
        var news = [NewEntity]()
        
        do {
            news = try context.fetch(fetchRequest)
            news.forEach { print("\($0.title) \($0.text) \($0.urlString) \n") }
        } catch let error {
            print(error.localizedDescription)
        }
        
        var adaptedNews = [News]()
        news.forEach {
            let new = coreDataAdaptNews(news: $0)
            adaptedNews.append(new)
        }
        
        return adaptedNews
    }
    
    func addProductToNews(news: News) {
        let context = self.viewContext
        let newsEntity = NSEntityDescription.insertNewObject(forEntityName: "NewEntity",
                                                                into: context)
        newsEntity.setValue(news.author, forKey: "author")
        newsEntity.setValue(news.title, forKey: "title")
        newsEntity.setValue(news.text, forKey: "text")
        newsEntity.setValue(news.urlString, forKey: "urlString")

        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteNewsFromAllNews() {
        let context = self.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "NewEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deleteProductFromNews(news: News) {
        let context = self.viewContext
        let fetchRequest = NSFetchRequest<NewEntity>(entityName: "NewEntity")
        var fetchedNews = [NewEntity]()
        
        do {
            fetchedNews = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        fetchedNews.forEach {
            if $0.author == news.author && $0.title == news.title
                    && $0.text == news.text && $0.urlString == news.urlString {
                context.delete($0)
            }
        }
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
