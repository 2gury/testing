import XCTest
import CoreData
@testable import SomeNews

class MockCatalogView: NewsInputProtocol {
    var isSuccess: Bool? = nil
    func success() {
        isSuccess = true
    }
    
    func failure() {
        isSuccess = false
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var news: [News]!
    
    init() {}
    
    convenience init(products: [News]) {
        self.init()
        self.news = [News]()
        self.news.append(contentsOf: products)
    }
    
    func fetchNews(completion: @escaping (Result<[News]?, Error>) -> ()) {
        if let news = self.news {
            var dailyNews = [News]()
            dailyNews.append(News())
            completion(.success(dailyNews))
        } else {
            let error = NSError(domain: "", code: 0 , userInfo: nil)
            completion(.failure(error))
        }
    }
}

class NewsViewTest: XCTestCase {
    var view: MockCatalogView!
    var presenter: NewsOutputProtocol!
    var networkService: NetworkServiceProtocol!
    var router: RouterNewsProtocol!
    var news: News!
    
    override func setUp() {
        let navigationController = UINavigationController()
        let builder = BuilderNews()
        news = News(author: "Dummy", title: "Dummy", text: "Dummy", urlString: "")
        router = RouterNews(navigationController: navigationController, builder: builder)
    }
    
    override func tearDown() {
        view = nil
        news = nil
        presenter = nil
        networkService = nil
    }
    
    func testGetSuccess() throws {
        // Arrange
        view = MockCatalogView()
        networkService = MockNetworkService(products: [news])
        presenter = NewsPresenter(view: view, networkService: networkService, router: router)
        
        var geting_roducts: [News]?
        
        // Act
        networkService.fetchNews { (result) in
            switch result {
            case .success(let news):
                geting_roducts = news
                self.view.success()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Assert
        XCTAssertNotNil(view.isSuccess)
        XCTAssertEqual(view.isSuccess, true)
        XCTAssertNotEqual(geting_roducts?.count, 0)
    }
    
    func testGetFailure() throws {
        // Arrange
        view = MockCatalogView()
        networkService = MockNetworkService()
        presenter = NewsPresenter(view: view, networkService: networkService, router: router)
        
        var catchError: Error?
        
        // Act
        networkService.fetchNews { (result) in
            switch result {
            case .success:
                print("Success")
            case .failure(let error):
                catchError = error
                self.view.failure()
            }
        }
        
        // Assert
        XCTAssertNotNil(view.isSuccess)
        XCTAssertEqual(view.isSuccess, false)
        XCTAssertNotNil(catchError)
    }
}
