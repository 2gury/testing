import XCTest
import CoreData
@testable import SomeNews

class AddIntegrationTest: XCTestCase {
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
        coreDataManagerTst.addProductToAdd(news: news1)
        coreDataManagerTst.addProductToAdd(news: news2)
        let news = coreDataManagerTst.getAdd()
        
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
        coreDataManagerTst.addProductToAdd(news: new)
        let news = coreDataManagerTst.getAdd()
        var findedAdd: News? = nil
        news.forEach { (arrNews) in
            if (arrNews.author == new.author && arrNews.title == new.title && arrNews.text == new.text && arrNews.urlString == new.urlString) {
                findedAdd = new
            }
        }

        // Assert
        XCTAssertNotNil(findedAdd)
        XCTAssertEqual(findedAdd?.author, new.author)
        XCTAssertEqual(findedAdd?.title, new.title)
        XCTAssertEqual(findedAdd?.text, new.text)
        XCTAssertEqual(findedAdd?.urlString, new.urlString)
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
