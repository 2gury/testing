import UIKit

protocol NewsInputProtocol: class {
    func success()
    func failure()
}

protocol NewsOutputProtocol: class {
    init(view: NewsInputProtocol, networkService: NetworkServiceProtocol, router: RouterNewsProtocol)
    func tapOnDetail(news: News?)
    func fetchNews()
    func getNews() -> [News]?
}

class NewsPresenter: NewsOutputProtocol {
    var view: NewsInputProtocol!
    var networkService: NetworkServiceProtocol!
    var router: RouterNewsProtocol!
    
    var initialNews: [News]?
    var news: [News]?
    
    required init(view: NewsInputProtocol, networkService: NetworkServiceProtocol, router: RouterNewsProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func fetchNews() {
        networkService.fetchNews { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedNews):
                self.initialNews = fetchedNews
                self.news = fetchedNews
                self.view.success()
            case .failure(let error):
                print(error.localizedDescription)
                self.view.failure()
            }
        }
    }
    
    func getNews() -> [News]? {
        return news
    }
    
    func tapOnDetail(news: News?) {
        guard let news = news else { return }
        router.showDetailNews(news: news)
    }
}

