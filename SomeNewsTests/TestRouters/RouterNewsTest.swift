import XCTest
@testable import SomeNews

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class RouterNewsTest: XCTestCase {
    var router: RouterNews!
    var builder = BuilderNews()
    var navigationController = MockNavigationController()
    
    
    override func setUp() {
        router = RouterNews(navigationController: navigationController, builder: builder)
    }
    
    override func tearDown() {
        router = nil
    }
    
    func testRouter() throws {
        // Arrange
        
        // Act
        router.showDetailNews(news: News(author: "Dummy", title: "Dummy", text: "Dummy", urlString: ""))
        let detailViewController = navigationController.presentedVC
        
        // Assert
        XCTAssertNotNil(detailViewController)
        XCTAssertTrue(detailViewController is DetailNews)
    }
}

