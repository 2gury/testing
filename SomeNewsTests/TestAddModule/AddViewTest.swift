import XCTest
import CoreData
@testable import SomeNews

class MockCartView: AddInputProtocol {
    public var isSuccess: Bool?
    func success() {
        isSuccess = true
    }
    
    func failure() {
        isSuccess = false
    }
}

class MockCoreDataForCart: AddAccessProtocol {
    public var success: Bool = true
    func getAdd() -> [News] {
        if success == true {
            return [News()]
        } else {
            return [News]()
        }
    }
}

class AddViewTest: XCTestCase {
    var view: MockCartView!
    var coreDataManager: AddAccessProtocol!
    var router: RouterAddProtocol!
    var presenter: AddOutputProtocol!
    var news: News!
    
    override func setUp() {
        let navigationController = MockNavigationController()
        let builder = BuilderAdd()
        router = RouterAdd(navigationController: navigationController, builder: builder)
        coreDataManager = CoreDataManagerTst()
        news = News(author: "Dummy", title: "Dummy", text: "Dummy", urlString: "")
    }
    
    override func tearDown() {
        view = nil
        news = nil
        coreDataManager = nil
        router = nil
        presenter = nil
    }
    
    func testGetSuccess() throws {
        // Arrange
        view = MockCartView()
        let coreDataManager = MockCoreDataForCart()
        presenter = AddPresenter(view: view, coreDataManager: coreDataManager, router: router)
        
        // Act
        presenter.fetchAdd()
        
        // Assert
        XCTAssertNotNil(view.isSuccess)
        XCTAssertEqual(view.isSuccess, true)
    }
    
    func testGetFailure() throws {
        // Arrange
        view = MockCartView()
        presenter = AddPresenter(view: view, coreDataManager: coreDataManager, router: router)
        
        // Act
        presenter.fetchAdd()
        
        // Assert
        XCTAssertNotNil(view.isSuccess)
        XCTAssertEqual(view.isSuccess, false)
    }
}
