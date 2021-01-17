import XCTest

class AddViewUITest: XCTestCase {

    func testAddNewsExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars["Tab Bar"].children(matching: .button).element(boundBy: 2).tap()
        
        let addNewsStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Add news"]/*[[".buttons[\"Add news\"].staticTexts[\"Add news\"]",".staticTexts[\"Add news\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        addNewsStaticText.tap()
        addNewsStaticText.tap()
        addNewsStaticText.tap()
        
    }
    
    func testRemoveNewsExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars["Tab Bar"].children(matching: .button).element(boundBy: 2).tap()
        
        let addNewsStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Add news"]/*[[".buttons[\"Add news\"].staticTexts[\"Add news\"]",".staticTexts[\"Add news\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let tableview3Table = app.tables["TableView3"]
        
        addNewsStaticText.tap()
        addNewsStaticText.tap()
        addNewsStaticText.tap()
        
        tableview3Table.cells["AddCell0"].buttons["emptyFavourite"].press(forDuration: 0.6);
        tableview3Table.cells["AddCell1"].buttons["emptyFavourite"].press(forDuration: 0.6);
        tableview3Table.cells["AddCell2"].buttons["emptyFavourite"].press(forDuration: 0.6);
    }
}
