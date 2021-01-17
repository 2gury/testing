import XCTest

class NewsViewUITest: XCTestCase {
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let tableview1Table = app.tables["TableView1"]
        let backButton = app.navigationBars["SomeNews.DetailNews"].buttons["Back"]
        
        tableview1Table.cells.element(matching: .cell, identifier: "NewsCell0").tap()
        backButton.tap()
        tableview1Table.cells["NewsCell0"].buttons["emptyFavourite"]/*@START_MENU_TOKEN@*/.press(forDuration: 0.6);/*[[".tap()",".press(forDuration: 0.6);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        tableview1Table.cells.element(matching: .cell, identifier: "NewsCell1").tap()
        backButton.tap()
        tableview1Table.cells["NewsCell1"].buttons["emptyFavourite"]/*@START_MENU_TOKEN@*/.press(forDuration: 0.6);/*[[".tap()",".press(forDuration: 0.6);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        app.swipeUp()
        
        tableview1Table.cells.element(matching: .cell, identifier: "NewsCell4").tap()
        backButton.tap()
        tableview1Table.cells["NewsCell4"].buttons["emptyFavourite"].press(forDuration: 0.6);
    }
}
