import UIKit

protocol BuilderFavouriteProtocol: class {
    func buildFavouriteModule(router: RouterFavouriteProtocol) -> UIViewController
    func buildDetailView(news: News?) -> UIViewController
}

final class BuilderFavourite: BuilderFavouriteProtocol {
    func buildFavouriteModule(router: RouterFavouriteProtocol) -> UIViewController {
        let view = FavouriteNewsView()
        let coreDataManager = CoreDataManager()
        let presenter = FavouritePresenter(view: view, coreDataManager: coreDataManager, router: router)
        view.presenter = presenter
        return view
    }
    
    func buildDetailView(news: News?) -> UIViewController {
        let detailVC = DetailNews()
        detailVC.news = news
        return detailVC
    }
}
