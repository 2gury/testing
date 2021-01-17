import UIKit
import CoreData
@testable import SomeNews

struct CoreDataManagerTst {
    private let core = CoreDataTestStack()
    static let shared = CoreDataManagerTst()
    
    internal var viewContext: NSManagedObjectContext {
        return core.mainContext
    }
}

extension CoreDataManagerTst: NewsAccessProtocol {
    func getNews() -> [News] {
        let context = self.viewContext
        let fetchRequest = NSFetchRequest<NewEntity>(entityName: "NewEntity")
        var catalogProducts = [NewEntity]()
        var news = [News]()
        
        do {
            catalogProducts = try context.fetch(fetchRequest)
            
            catalogProducts.forEach { (product) in
                news.append(CoreDataToNews(entity: product))
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        
        return news
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

extension CoreDataManagerTst: FavouriteAccessProtocol {
    func getFavourite() -> [News] {
        let context = self.viewContext
        let fetchRequest = NSFetchRequest<FavouriteNewsEntity>(entityName: "FavouriteNewsEntity")
        var favouriteProducts = [FavouriteNewsEntity]()
        var news = [News]()
        
        do {
            favouriteProducts = try context.fetch(fetchRequest)
            
            favouriteProducts.forEach { (product) in
                news.append(CoreDataToNews(entity: product))
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return news
    }
    
    func addProductToFavourite(news: News) {
        let context = self.viewContext
        let newsEntity = NSEntityDescription.insertNewObject(forEntityName: "FavouriteNewsEntity",
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
    
    func deleteProductFromFavourite(news: News) {
        let context = self.viewContext
        let fetchRequest = NSFetchRequest<FavouriteNewsEntity>(entityName: "FavouriteNewsEntity")
        var fetchedNews = [FavouriteNewsEntity]()
        
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

extension CoreDataManagerTst: AddAccessProtocol {
    func getAdd() -> [News] {
        let context = self.viewContext
        let fetchRequest = NSFetchRequest<AddNewsEntity>(entityName: "AddNewsEntity")
        var cartProducts = [AddNewsEntity]()
        var news = [News]()
        
        do {
            cartProducts = try context.fetch(fetchRequest)
            
            cartProducts.forEach { (product) in
                news.append(CoreDataToNews(entity: product))
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return news
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
