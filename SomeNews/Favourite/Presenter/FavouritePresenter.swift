import UIKit

protocol FavouriteInputProtocol: class {
    func success()
    func failure()
}

protocol FavouriteOutputProtocol: class {
    init(view: FavouriteInputProtocol, coreDataManager: FavouriteAccessProtocol, router: RouterFavouriteProtocol)
    func tapOnDetail(news: News?)
    func getFavouriteNews() -> [News]!
    func fetchFavourite()
}

class FavouritePresenter: FavouriteOutputProtocol {
    var view: FavouriteInputProtocol!
    var coreDataManager: FavouriteAccessProtocol!
    var router: RouterFavouriteProtocol!
    internal var _favouriteNews: [News]!
    
    required init(view: FavouriteInputProtocol, coreDataManager: FavouriteAccessProtocol, router: RouterFavouriteProtocol) {
        self.view = view
        self.coreDataManager = coreDataManager
        self.router = router
    }
    
    func getFavouriteNews() -> [News]! {
        return _favouriteNews
    }
    
    func fetchFavourite() {
        _favouriteNews = coreDataManager.getFavourite()
        if (!_favouriteNews.isEmpty) {
            view.success()
        } else {
            view.failure()
        }
    }
    
    func tapOnDetail(news: News?) {
        guard let news = news else { return }
        router.showDetailNews(news: news)
    }
}
