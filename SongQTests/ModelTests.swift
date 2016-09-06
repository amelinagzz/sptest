//
//  ModelTest.swift
//  spotifytest
//
//  Created by Adriana González on 9/5/16.
//  Copyright © 2016 AMGM. All rights reserved.
//

import XCTest
@testable import spotifytest

class ModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testInit_TempArtist() {
        let artist = TempArtist(idnum: "1", name: "The Offspring", uri: "5LfGQac0EIXyAN8aUwmNAQ")
        XCTAssertEqual(artist.idnum, "1")
        XCTAssertEqual(artist.name, "The Offspring")
        XCTAssertEqual(artist.uri, "5LfGQac0EIXyAN8aUwmNAQ")
    }
   
    func testInit_TempTrack() {
        let artist = TempArtist(idnum: "1", name: "The Offspring", uri: "5LfGQac0EIXyAN8aUwmNAQ")
        let track = TempTrack(idnum: "1", title: "The kids aren't alright", previewUrl: "someURL", uri: "someURi", artists: [artist], albumImageUrl: "someURL", ownerUri: "someURi")
        XCTAssertEqual(track.idnum, "1")
        XCTAssertEqual(track.title, "The kids aren't alright")
        XCTAssertEqual(track.previewUrl, "someURL")
        XCTAssertEqual(track.uri, "someURi")
        XCTAssertEqual(track.artists, [artist])
        XCTAssertEqual(track.albumImageUrl, "someURL")
        XCTAssertEqual(track.ownerUri, "someURi")


    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
