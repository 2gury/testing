import XCTest
import CoreData
@testable import SomeNews

class NewsIntegrationTest: XCTestCase {
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
        coreDataManagerTst.addProductToNews(news: news1)
        coreDataManagerTst.addProductToNews(news: news2)
        let news = coreDataManagerTst.getNews()
        
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
        coreDataManagerTst.addProductToNews(news: new)
        let news = coreDataManagerTst.getNews()
        var findedNews: News? = nil
        news.forEach { (arrNews) in
            if (arrNews.author == new.author && arrNews.title == new.title && arrNews.text == new.text && arrNews.urlString == new.urlString) {
                findedNews = new
            }
        }

        // Assert
        XCTAssertNotNil(findedNews)
        XCTAssertEqual(findedNews?.author, new.author)
        XCTAssertEqual(findedNews?.title, new.title)
        XCTAssertEqual(findedNews?.text, new.text)
        XCTAssertEqual(findedNews?.urlString, new.urlString)
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
