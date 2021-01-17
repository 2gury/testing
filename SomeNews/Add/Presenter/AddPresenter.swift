import UIKit

protocol AddInputProtocol: class {
    func success()
    func failure()
}

protocol AddOutputProtocol: class {
    init(view: AddInputProtocol, coreDataManager: AddAccessProtocol, router: RouterAddProtocol)
    func tapOnDetail(news: News?)
    func getAddProducts() -> [News]!
    func fetchAdd()
    
}

class AddPresenter: AddOutputProtocol {
    var view: AddInputProtocol!
    var coreDataManager: AddAccessProtocol!
    var router: RouterAddProtocol!
    internal var _addNews: [News]!
    
    required init(view: AddInputProtocol, coreDataManager: AddAccessProtocol, router: RouterAddProtocol) {
        self.view = view
        self.coreDataManager = coreDataManager
        self.router = router
    }
    
    func getAddProducts() -> [News]! {
        return _addNews
    }
    
    func fetchAdd() {
        _addNews = coreDataManager.getAdd()
        if (!_addNews.isEmpty) {
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
