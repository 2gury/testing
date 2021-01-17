import XCTest
import CoreData
@testable import SomeNews

class MockAddPresenter: AddOutputProtocol {
    var isInited: Bool? = nil
    required init(view: AddInputProtocol, coreDataManager: AddAccessProtocol, router: RouterAddProtocol) {
        isInited = true
    }
    
    var isTapOnDetail: Bool? = nil
    var news: News?
    func tapOnDetail(news: News?) {
        isTapOnDetail = true
        self.news = news
    }
    
    var isGetAddProducts: Bool? = nil
    func getAddProducts() -> [News]! {
        isGetAddProducts = true
        return [News(), News(), News()]
    }
    
    var isFetchAdd: Bool? = nil
    func fetchAdd() {
        isFetchAdd = true
    }
}

class AddPresenterTest: XCTestCase {
    var view: AddNewsView!
    var coreDataManager: AddAccessProtocol!
    var router: RouterAddProtocol!
    var presenter: MockAddPresenter!
    var news: News!
    
    override func setUp() {
        let navigationController = MockNavigationController()
        let builder = BuilderAdd()
        news = News(author: "Dummy", title: "Dummy", text: "Dummy", urlString: "")
        router = RouterAdd(navigationController: navigationController, builder: builder)
        coreDataManager = CoreDataManagerTst()
    }
    
    override func tearDown() {
        view = nil
        news = nil
        coreDataManager = nil
        router = nil
        presenter = nil
    }
    
    func testInit() throws {
        // Arrange
        view = AddNewsView()
        
        // Act
        presenter = MockAddPresenter(view: view, coreDataManager: coreDataManager, router: router)
        
        // Assert
        XCTAssertNotNil(presenter.isInited)
        XCTAssertEqual(presenter.isInited, true)
        
    }
    
    func testFetchAddNews() throws {
        // Arrange
        view = AddNewsView()
        presenter = MockAddPresenter(view: view, coreDataManager: coreDataManager, router: router)
        view.presenter = presenter
        
        // Act
        view.presenter.fetchAdd()
        
        // Assert
        XCTAssertNotNil(presenter.isFetchAdd)
        XCTAssertEqual(presenter.isFetchAdd, true)
        
    }
    
    func testGetAddNews() throws {
        // Arrange
        view = AddNewsView()
        presenter = MockAddPresenter(view: view, coreDataManager: coreDataManager, router: router)
        view.presenter = presenter
        
        // Act
        let newsGet = view.presenter.getAddProducts()
        
        // Assert
        XCTAssertEqual(newsGet?.isEmpty, false)
        XCTAssertEqual(presenter.isGetAddProducts, true)
    }
    
    func testTapOnProduct() throws {
        // Arrange
        view = AddNewsView()
        presenter = MockAddPresenter(view: view, coreDataManager: coreDataManager, router: router)
        view.presenter = presenter
        
        // Act
        view.presenter.tapOnDetail(news: news)
        
        // Assert
        XCTAssertNotNil(presenter.news)
        XCTAssertEqual(news, presenter.news)
    }
}
