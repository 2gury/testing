import UIKit

protocol BuilderAddProtocol: class {
    func buildAddModule(router: RouterAddProtocol) -> UIViewController
    func buildDetailView(news: News?) -> UIViewController
}

final class BuilderAdd: BuilderAddProtocol {
    func buildAddModule(router: RouterAddProtocol) -> UIViewController {
        let view = AddNewsView()
        let coreDataManager = CoreDataManager()
        let presenter = AddPresenter(view: view, coreDataManager: coreDataManager, router: router)
        view.presenter = presenter
        return view
    }
    
    func buildDetailView(news: News?) -> UIViewController {
        let detailVC = DetailNews()
        detailVC.news = news
        return detailVC
    }
}
