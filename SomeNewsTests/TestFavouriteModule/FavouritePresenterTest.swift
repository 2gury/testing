import XCTest
import CoreData
@testable import SomeNews

class MockFavouritePresenter: FavouriteOutputProtocol {
    var isInited: Bool? = nil
    required init(view: FavouriteInputProtocol, coreDataManager: FavouriteAccessProtocol, router: RouterFavouriteProtocol) {
        isInited = true
    }
    
    var isTapOnDetail: Bool? = nil
    var news: News?
    func tapOnDetail(news: News?) {
        isTapOnDetail = true
        self.news = news
    }
    
    var isGetFavouriteProducts: Bool? = nil
    func getFavouriteNews() -> [News]! {
        isGetFavouriteProducts = true
        return [News(), News(), News()]
    }
    
    var isFetchFavourite: Bool? = nil
    func fetchFavourite() {
        isFetchFavourite = true
    }
}

class FavouritePresenterTest: XCTestCase {
    var view: FavouriteNewsView!
    var presenter: MockFavouritePresenter!
    var router: RouterFavouriteProtocol!
    var coreDataManager: FavouriteAccessProtocol!
    var news: News!

    override func setUp() {
        let navigationController = UINavigationController()
        let builder = BuilderFavourite()
        news = News(author: "Dummy", title: "Dummy", text: "Dummy", urlString: "")
        router = RouterFavourite(navigationController: navigationController, builder: builder)
    }
    
    override func tearDown() {
        view = nil
        news = nil
        presenter = nil
        coreDataManager = nil
    }
    
    func testFetchFavourite() throws {
        // Arrange
        view = FavouriteNewsView()
        coreDataManager = CoreDataManagerTst()
        presenter = MockFavouritePresenter(view: view, coreDataManager: coreDataManager, router: router)
        view.presenter = presenter
        
        // Act
        view.presenter.fetchFavourite()
        
        // Assert
        XCTAssertEqual(presenter.isFetchFavourite, true)
        XCTAssertNotNil(presenter.isFetchFavourite)
    }
    
    func testGetFavouriteProducts() throws {
        // Arrange
        view = FavouriteNewsView()
        coreDataManager = CoreDataManagerTst()
        presenter = MockFavouritePresenter(view: view, coreDataManager: coreDataManager, router: router)
        view.presenter = presenter
        
        // Act
        let products = view.presenter.getFavouriteNews()
        
        // Assert
        XCTAssertEqual(products?.isEmpty, false)
        XCTAssertEqual(presenter.isGetFavouriteProducts, true)
    }
    
    func testTapOnDetail() throws {
        // Arrange
        view = FavouriteNewsView()
        coreDataManager = CoreDataManagerTst()
        presenter = MockFavouritePresenter(view: view, coreDataManager: coreDataManager, router: router)
        view.presenter = presenter
        
        // Act
        view.presenter.tapOnDetail(news: news)
        
        // Assert
        XCTAssertEqual(news, presenter.news)
        XCTAssertNotNil(presenter.isTapOnDetail)
        XCTAssertEqual(presenter.isTapOnDetail, true)
    }
}
