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

        let expectedURL = "https://api.themoviedb.org/3/movies/get-now-playing?api_key=7d758c986ac4f389a8ffe19bbf626715"

        service.getNowPlayingMovies() { (error) in

        }

        guard let urlString = mockNetworkRequestService.urlRequestMade?.url?.absoluteString else {
            XCTFail("Didn't receive url string")
            return
        }

        XCTAssertEqual(urlString, expectedURL)
    }
}
