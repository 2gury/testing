import XCTest
import CoreData
@testable import SomeNews

class MockNewsPresenter: NewsOutputProtocol {
    var isInited: Bool? = nil
    required init(view: NewsInputProtocol, networkService: NetworkServiceProtocol, router: RouterNewsProtocol) {
        isInited = true
    }
    
    var isTapOnDetail: Bool? = nil
    func tapOnDetail(news: News?) {
        isTapOnDetail = true
    }
    
    var isFetchNews: Bool? = nil
    func fetchNews() {
        isFetchNews = true
    }
    
    var isGetNews: Bool? = nil
    func getNews() -> [News]? {
        isGetNews = true
        return [News(), News(), News()]
    }
}

class NewsPresenterTest: XCTestCase {
    var view: NewsInputProtocol!
    var presenter: MockNewsPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterNewsProtocol!
    var news: News!
    
    override func setUp() {
        let navigationController = UINavigationController()
        let builder = BuilderNews()
        router = RouterNews(navigationController: navigationController, builder: builder)
        news = News(author: "Dummy", title: "Dummy", text: "Dummy", urlString: "")
        networkService = NetworkService()
    }
    
    override func tearDown() {
        view = nil
        news = nil
        presenter = nil
        networkService = nil
    }
    
    func testInit() throws {
        // Arrange
        // Act
        let view = NewsView()
        presenter = MockNewsPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        
        // Assert
        XCTAssertNotNil(presenter.isInited)
        XCTAssertEqual(presenter.isInited, true)
    }
    
    func testTapOnDetail() throws {
        // Arrange
        let view = NewsView()
        presenter = MockNewsPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        
        // Act
        presenter.tapOnDetail(news: News())
        
        // Assert
        XCTAssertNotNil(presenter.isTapOnDetail)
        XCTAssertEqual(presenter.isTapOnDetail, true)
    }
    
    func testFetchNews() throws {
        // Arrange
        let view = NewsView()
        presenter = MockNewsPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        
        // Act
        presenter.fetchNews()
        
        // Assert
        XCTAssertNotNil(presenter.isFetchNews)
        XCTAssertEqual(presenter.isFetchNews, true)
    }
    
    func testGetNews() throws {
        // Arrange
        let view = NewsView()
        presenter = MockNewsPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        
        // Act
        let getNews = presenter.getNews()
        
        // Assert
        XCTAssertNotNil(getNews)
        XCTAssertNotNil(presenter.isGetNews)
        XCTAssertEqual(presenter.isGetNews, true)
    }
}
