import Foundation

import XCTest

class E2EUITest: XCTestCase {
    func testE2E() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tableview1Table = app.tables["TableView1"]
        tableview1Table.cells["NewsCell0"].buttons["emptyFavourite"].tap()
        tableview1Table.cells.element(matching: .cell, identifier: "NewsCell0").tap()
        app.navigationBars["SomeNews.DetailNews"].buttons["Back"].tap()
        
        tableview1Table.cells["NewsCell1"].buttons["emptyFavourite"].tap()
        tableview1Table.cells.element(matching: .cell, identifier: "NewsCell1").tap()
        app.navigationBars["SomeNews.DetailNews"].buttons["Back"].tap()
        
        tableview1Table.cells["NewsCell2"].buttons["emptyFavourite"]/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 1.1);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        tableview1Table.cells.element(matching: .cell, identifier: "NewsCell2").tap()
        app.navigationBars["SomeNews.DetailNews"].buttons["Back"].tap()
        
        tableview1Table.cells["NewsCell3"].buttons["emptyFavourite"]/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 1.1);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        tableview1Table.cells.element(matching: .cell, identifier: "NewsCell3").tap()
        app.navigationBars["SomeNews.DetailNews"].buttons["Back"].tap()
        
        tableview1Table.cells["NewsCell4"].buttons["emptyFavourite"]/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 1.1);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        tableview1Table.cells.element(matching: .cell, identifier: "NewsCell4").tap()
        app.navigationBars["SomeNews.DetailNews"].buttons["Back"].tap()
        
        XCUIApplication().tabBars["Tab Bar"].children(matching: .button).element(boundBy: 2).tap()
        
        //        tableview3Table.cells["AddCell0"].buttons["filledFavourite"].tap()
        
        let addNewsStaticText = XCUIApplication()/*@START_MENU_TOKEN@*/.staticTexts["Add news"]/*[[".buttons[\"Add news\"].staticTexts[\"Add news\"]",".staticTexts[\"Add news\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        addNewsStaticText.tap()
        addNewsStaticText.tap()
        addNewsStaticText.tap()
        
        let tableview3Table = XCUIApplication().tables["TableView3"]
        tableview3Table.cells["AddCell0"].buttons["emptyFavourite"]/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 0.5);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        tableview3Table.cells["AddCell1"].buttons["emptyFavourite"].tap()
        tableview3Table.cells["AddCell2"].buttons["emptyFavourite"].tap()
        
        XCUIApplication().tabBars["Tab Bar"].children(matching: .button).element(boundBy: 1).tap()
        //
        let tableview2Table = app.tables["TableView2"]
        tableview2Table.cells["FavouriteCell0"].buttons["filledFavourite"].tap()
        tableview2Table.cells["FavouriteCell0"].buttons["filledFavourite"].tap()
        tableview2Table.cells["FavouriteCell0"].buttons["filledFavourite"].tap()
        tableview2Table.cells["FavouriteCell0"].buttons["filledFavourite"].tap()
        tableview2Table.cells["FavouriteCell0"].buttons["filledFavourite"].tap()
        tableview2Table.cells["FavouriteCell0"].buttons["filledFavourite"].tap()
        tableview2Table.cells["FavouriteCell0"].buttons["filledFavourite"].tap()
    }
}
