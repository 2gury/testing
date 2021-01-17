import XCTest
@testable import SomeNews

class RouterAddTest: XCTestCase {
    var router: RouterAdd!
    var builder = BuilderAdd()
    var navigationController = MockNavigationController()
    
    override func setUp() {
        router = RouterAdd(navigationController: navigationController, builder: builder)
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
