import XCTest
import CoreData
@testable import SomeNews

class FavouriteIntegrationTest: XCTestCase {
    var coreDataManagerTst: CoreDataManagerTst!
    
    override func setUp() {
        coreDataManagerTst = CoreDataManagerTst()
    }
    
    override func tearDown() {
        coreDataManagerTst = nil
    }
    
    func testFetchNews() throws {
        // Arrange
        let news1 = News(author: "Dummy author 1", title: "Dummy title", text: "Dummy text", urlString: "")
        let news2 = News(author: "Dummy author 2", title: "Dummy title", text: "Dummy text", urlString: "")
        
        // Act
        coreDataManagerTst.addProductToFavourite(news: news1)
        coreDataManagerTst.addProductToFavourite(news: news2)
        let news = coreDataManagerTst.getFavourite()
        
        // Assert
        XCTAssertEqual(news.count, 2)
        
        news.forEach {
            if ($0.author != news1.author && $0.author != news2.author) {
                XCTAssert(false)
            }
        }
    }
    
    func testAddNews() throws {
        // Arrange
        let new = News(author: "Dummy author 1", title: "Dummy title", text: "Dummy text", urlString: "")

        // Act
        coreDataManagerTst.addProductToFavourite(news: new)
        let news = coreDataManagerTst.getFavourite()
        var findedFavourite: News? = nil
        news.forEach { (arrNews) in
            if (arrNews.author == new.author && arrNews.title == new.title && arrNews.text == new.text && arrNews.urlString == new.urlString) {
                findedFavourite = new
            }
        }

        // Assert
        XCTAssertNotNil(findedFavourite)
        XCTAssertEqual(findedFavourite?.author, new.author)
        XCTAssertEqual(findedFavourite?.title, new.title)
        XCTAssertEqual(findedFavourite?.text, new.text)
        XCTAssertEqual(findedFavourite?.urlString, new.urlString)
    }
    
    func testDeleteNews() throws {
        // Arrange
        let new = News(author: "Dummy author 1", title: "Dummy title", text: "Dummy text", urlString: "")

        // Act
        coreDataManagerTst.addProductToNews(news: new)
        // fetch DB
        var news = coreDataManagerTst.getNews()
        XCTAssertNotEqual(news.count, 0)

        if news.count >= 1 {
            coreDataManagerTst.deleteProductFromNews(news: news.first!)
        }

        // Assert
        // refetch DB
        news = coreDataManagerTst.getNews()
        XCTAssertEqual(news.count, 0)
    }
}
