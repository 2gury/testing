import UIKit

// MARK:- News
protocol RouterFavouriteMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: BuilderFavouriteProtocol? { get set }
}

protocol RouterFavouriteProtocol: RouterFavouriteMain {
    func initialViewController()
    func showDetailNews(news: News?)
    func popToRoot()
}

class RouterFavourite: RouterFavouriteProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: BuilderFavouriteProtocol?
    
    init(navigationController: UINavigationController, builder: BuilderFavouriteProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = builder
    }
    
    func initialViewController() {
        guard let navigationController = navigationController else { return }
        guard let newsMVP = assemblyBuilder?.buildFavouriteModule(router: self) else { return }
        navigationController.viewControllers = [newsMVP]
    }
    
    func showDetailNews(news: News?) {
        
        guard let navigationController = navigationController else { return }
        guard let detailVC = assemblyBuilder?.buildDetailView(news: news) else { return }
        
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func popToRoot() {
        guard let navigationController = navigationController else { return }
        navigationController.popToRootViewController(animated: true)
    }
}
