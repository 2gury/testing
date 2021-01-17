import UIKit

protocol BuilderNewsProtocol: class {
    func buildNewsModule(router: RouterNewsProtocol) -> UIViewController
    func buildDetailView(news: News?) -> UIViewController
}

final class BuilderNews: BuilderNewsProtocol {    
    func buildNewsModule(router: RouterNewsProtocol) -> UIViewController {
        let view = NewsView()
        let networkService = NetworkService()
        let presenter = NewsPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func buildDetailView(news: News?) -> UIViewController {
        let detailVC = DetailNews()
        detailVC.news = news
        return detailVC
    }
}
