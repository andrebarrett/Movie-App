//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation
import XCTest
@testable import Movie_App

class NowPlayingMovieServiceTests: XCTestCase {

    var service: NowPlayingMovieService!
    var mockNetworkRequestService: MockNetworkService!
    var mockServiceParser: MockServiceParser!

    override func setUp() {
        super.setUp()
        mockNetworkRequestService = MockNetworkService()
        mockServiceParser = MockServiceParser()
        service = NowPlayingMovieServiceImpl(networkService: mockNetworkRequestService, serviceParser: mockServiceParser)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testService_CreatesValidURLForNowPlaying() {

        let expectedURL = "https://api.themoviedb.org/3/movie/now_playing?page=1&language=en-US&api_key=7d758c986ac4f389a8ffe19bbf626715"

        service.getNowPlayingMovies() { (error) in

        }

        guard let urlString = mockNetworkRequestService.urlRequestMade?.url?.absoluteString else {
            XCTFail("Didn't receive url string")
            return
        }

        XCTAssertEqual(urlString, expectedURL)
    }

    func testService_ParsesResponseData() {

        setupMockResponseData()

        service.getNowPlayingMovies() { (error) in

        }

        guard let dictionary = mockServiceParser.dictionaryPassed else {
            XCTFail("Didn't receive dictionary")
            return
        }

        guard let array = dictionary[MovieResponseAttributes.Results] as? [Dictionary<String, AnyObject>] else {
            XCTFail("Didn't receive array in dictionary")
            return
        }

        XCTAssertEqual(array.count, 20)
    }

    func setupMockResponseData() {
        guard let path = Bundle(for: NowPlayingMovieServiceTests.self).path(forResource: "NowPlayingResponse", ofType: "json") else {
            XCTFail("No json file found")
            return
        }

        guard let jsonString = try? String(contentsOfFile: path) else {
            XCTFail("No json string file found")
            return
        }

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("No json data available in string")
            return
        }

        mockNetworkRequestService.dataToReturn = jsonData
    }
}
