import Foundation
import CoreData

protocol AddAccessProtocol {
    func getAdd() -> [News]
}

extension CoreDataManager: AddAccessProtocol {
    func getAdd() -> [News] {
        let context = self.viewContext
        let fetchRequest = NSFetchRequest<AddNewsEntity>(entityName: "AddNewsEntity")
        var news = [AddNewsEntity]()
        
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
    
    func addProductToAdd(news: News) {
        let context = self.viewContext
        let newsEntity = NSEntityDescription.insertNewObject(forEntityName: "AddNewsEntity",
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
    
    func deleteNewsFromAdd() {
        let context = self.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AddNewsEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func deleteProductFromAdd(news: News) {
        let context = self.viewContext
        let fetchRequest = NSFetchRequest<AddNewsEntity>(entityName: "AddNewsEntity")
        var fetchedNews = [AddNewsEntity]()
        
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
