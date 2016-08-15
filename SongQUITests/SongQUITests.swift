//
//  SongQUITests.swift
//  SongQUITests
//
//  Created by Adriana Gonzalez on 7/11/16.
//  Copyright © 2016 AMGM. All rights reserved.
//

import XCTest

class SongQUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDiscoverTab() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]

        app.buttons["LOGIN"].tap()
        
        sleep(5)
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.childrenMatchingType(.Button).elementBoundByIndex(1).tap()
        
        XCTAssertEqual(app.tables.count, 1)
        
        let table = app.tables.elementBoundByIndex(0)
        
        let count = table.cells.count
        XCTAssert(count > 0)
        
        table.swipeDown()
        table.swipeUp()
        
    }
    
    func testFavoritesTab(){
        
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]

        app.buttons["LOGIN"].tap()
        
        sleep(5)
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.childrenMatchingType(.Button).elementBoundByIndex(0).tap()
        
        XCTAssertEqual(app.tables.count, 1)
        
        let table = app.tables.elementBoundByIndex(0)
        table.tap()
        table.swipeDown()
        table.swipeUp()

    }
    
    func testProfileTab(){
        
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]

        app.buttons["LOGIN"].tap()
        
        sleep(5)
        
        app.tabBars.childrenMatchingType(.Button).elementBoundByIndex(2).tap()
        app.buttons["LOGOUT"].tap()
        
    }
    
    func testAddToFavs(){
        
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]

        app.buttons["LOGIN"].tap()
        sleep(5)

        app.tables.staticTexts["alternative"].tap()
        sleep(2)
        app.buttons["favs red icon"].tap()
        sleep(1)
        app.navigationBars["Alternative"].buttons["Back"].tap()

        
    }
    
    func testSkip(){
        
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]

        app.buttons["LOGIN"].tap()
        sleep(5)
        
        app.tables.staticTexts["alternative"].tap()
        sleep(2)
        app.buttons["next icon"].tap()
        sleep(1)
        app.buttons["next icon"].tap()
        sleep(1)
        app.navigationBars["Alternative"].buttons["Back"].tap()
        
    }
    
    func testSearchBar(){
        
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]

        app.buttons["LOGIN"].tap()
        sleep(5)

        XCTAssertEqual(app.tables.count, 1)
        
        let table = app.tables.elementBoundByIndex(0)
        
        let allCells = table.cells.count
        print(allCells)

        let searchField = table.searchFields["Search"]
        searchField.tap()
        searchField.typeText("Disney")
        
        let filteredCells = table.cells.count
        XCTAssert(filteredCells == 1)
        
        XCUIApplication().tables.buttons["Cancel"].tap()
        
        XCTAssert(table.cells.count == allCells)
        
        searchField.tap()
        app.otherElements["Double-tap to dismiss"].tap()
        
    }
    
    func testDeleteSong(){
        
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]
        
        app.buttons["LOGIN"].tap()
        
        sleep(5)
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.childrenMatchingType(.Button).elementBoundByIndex(0).tap()

        
        let firstChild = app.tables.childrenMatchingType(.Any).elementBoundByIndex(0)
        if firstChild.exists {
            firstChild.swipeLeft()
            
            firstChild.childrenMatchingType(.Button).matchingIdentifier("delete icon").elementBoundByIndex(0).tap()
            print(app.debugDescription)
            
        }
        
    }
    
}
