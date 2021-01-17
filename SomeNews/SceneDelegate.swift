import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Catalog Module
        let newsNavigationController = UINavigationController()
        let newsBuilder = BuilderNews()
        let routerNews = RouterNews(navigationController: newsNavigationController,
                                          builder: newsBuilder)
        routerNews.initialViewController()
        if let newsEmptyDataImg = UIImage(named: "newsEmpty")?.pngData(), let newsFilledDataImg = UIImage(named: "newsFilled")?.pngData() {
            let emptyImg = UIImage(data: newsEmptyDataImg, scale: 8)
            let filledImg = UIImage(data: newsFilledDataImg, scale: 8)
            let barItem = UITabBarItem(title: "", image: emptyImg, selectedImage: filledImg)
            newsNavigationController.tabBarItem = barItem
        }
        
        // Favourite Module
        let favouriteNavigationController = UINavigationController()
        let favouriteBuilder = BuilderFavourite()
        let routerFavourite = RouterFavourite(navigationController: favouriteNavigationController,
                                          builder: favouriteBuilder)
        routerFavourite.initialViewController()
        if let favouriteEmptyDataImg = UIImage(named: "emptyFavourite")?.pngData(), let favouriteFilledDataImg = UIImage(named: "filledFavourite")?.pngData() {
            let emptyImg = UIImage(data: favouriteEmptyDataImg, scale: 7)
            let filledImg = UIImage(data: favouriteFilledDataImg, scale: 7)
            let barItem = UITabBarItem(title: "", image: emptyImg, selectedImage: filledImg)
            favouriteNavigationController.tabBarItem = barItem
        }
        
        // Cart Module
        let addNavigationController = UINavigationController()
        let addBuilder = BuilderAdd()
        let routerAdd = RouterAdd(navigationController: addNavigationController,
                                          builder: addBuilder)
        routerAdd.initialViewController()
        if let addEmptyDataImg = UIImage(named: "addEmpty")?.pngData(), let addFilledDataImg = UIImage(named: "addFilled")?.pngData() {
            let emptyImg = UIImage(data: addEmptyDataImg, scale: 7.4)
            let filledImg = UIImage(data: addFilledDataImg, scale: 7.4)
            let barItem = UITabBarItem(title: "", image: emptyImg, selectedImage: filledImg)
            addNavigationController.tabBarItem = barItem
        }
        
        // Tab Bar Module
        let tabBar = UITabBarController()
        tabBar.setViewControllers([newsNavigationController,
                                   favouriteNavigationController,
                                   addNavigationController],
                                  animated: true)
        
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        tabBar.selectedViewController = newsNavigationController
        window.rootViewController = tabBar
        self.window = window
        window.makeKeyAndVisible()
        
        //
        //
        // MARK:- Refill Data Base
        refillDataBase()
    }
    
    func refillDataBase() {
        let allNews = CoreDataManager.shared.getNews()
        allNews.forEach { (news) in
            CoreDataManager.shared.deleteProductFromNews(news: news)
        }
        coreDataNews.forEach { (news) in
            CoreDataManager.shared.addProductToNews(news: news)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

