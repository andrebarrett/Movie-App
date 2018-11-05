//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import XCTest
@testable import Movie_App

class NowPlayingMovieServiceParserTests: XCTestCase {

    var serviceParser: MovieServiceParser!
    var parsedMovies: [Movie]?

    override func setUp() {
        super.setUp()

        serviceParser = MovieServiceParser()
        serviceParser.delegate = self
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParse_ParsesSuccessfully() {

        guard let dictionary = jsonDictionary(fromFileName: "NowPlayingResponse") else {
            XCTFail("No json dictionary found")
            return
        }

        let success = serviceParser.parseMovieDataDictionary(dictionary)

        XCTAssert(success)
    }

    func testParse_ParsesMovie() {

        guard let dictionary = jsonDictionary(fromFileName: "NowPlayingResponse") else {
            XCTFail("No json dictionary found")
            return
        }

        _ = serviceParser.parseMovieDataDictionary(dictionary)

        guard let item = parsedMovies?.first else {
            XCTFail("No items parsed")
            return
        }

        XCTAssertEqual(item.id, 297761)
        XCTAssertEqual(item.title, "Suicide Squad")
        XCTAssertEqual(item.language, "en")
        XCTAssertEqual(item.backdropPath, "/ndlQ2Cuc3cjTL7lTynw6I4boP4S.jpg")
        XCTAssertEqual(item.posterPath, "/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg")
        XCTAssertEqual(item.overview, "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.")

    }


    func jsonDictionary(fromFileName file: String) -> [String: AnyObject]? {

        guard let path = Bundle(for: NowPlayingMovieServiceParserTests.self).path(forResource: file, ofType: "json") else {
            XCTFail("No json file found")
            return nil
        }

        guard let jsonString = try? String(contentsOfFile: path) else {
            XCTFail("No json string file found")
            return nil
        }

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("No json data available in string")
            return nil
        }

        guard let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) else {
            XCTFail("No json parsable in data")
            return nil
        }

        return jsonResult as? [String: AnyObject]
    }
}

extension NowPlayingMovieServiceParserTests: MovieServiceParserDelegate {
    func parser(_ parser: ServiceParser, didParse movies: [Movie]) {
        self.parsedMovies = movies
    }
}
