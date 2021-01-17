import UIKit

// MARK:- Add
protocol RouterAddMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: BuilderAddProtocol? { get set }
}

protocol RouterAddProtocol: RouterAddMain {
    func initialViewController()
    func showDetailNews(news: News?)
    func popToRoot()
}

class RouterAdd: RouterAddProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: BuilderAddProtocol?
    
    init(navigationController: UINavigationController, builder: BuilderAddProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = builder
    }
    
    func initialViewController() {
        guard let navigationController = navigationController else { return }
        guard let newsMVP = assemblyBuilder?.buildAddModule(router: self) else { return }
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
