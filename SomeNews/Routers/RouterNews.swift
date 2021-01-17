import UIKit

// MARK:- News
protocol RouterNewsMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: BuilderNewsProtocol? { get set }
}

protocol RouterNewsProtocol: RouterNewsMain {
    func initialViewController()
    func showDetailNews(news: News?)
    func popToRoot()
}

class RouterNews: RouterNewsProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: BuilderNewsProtocol?
    
    init(navigationController: UINavigationController, builder: BuilderNewsProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = builder
    }
    
    func initialViewController() {
        guard let navigationController = navigationController else { return }
        guard let newsMVP = assemblyBuilder?.buildNewsModule(router: self) else { return }
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
