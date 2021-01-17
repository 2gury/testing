import XCTest
@testable import SomeNews

class RouterFavouriteTest: XCTestCase {
    var router: RouterFavourite!
    var builder = BuilderFavourite()
    var navigationController = MockNavigationController()
    
    
    override func setUp() {
        router = RouterFavourite(navigationController: navigationController, builder: builder)
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
