//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation
@testable import Movie_App

class MockServiceParser: ServiceParser {

    var delegate: MovieServiceParserDelegate?

    var dictionaryPassed: [String: AnyObject]?

    func parseMovieDataDictionary(_ dictionary: [String : AnyObject]) -> Bool {
        dictionaryPassed = dictionary
        let movie = Movie(id: 123, title: "Some Movie", releaseDate: "10-10-2015", overview: "Some description", language: "en", popularity: 4.8, posterPath: "/poster.jpg", backdropPath: "/backdrop.jpg")

        delegate?.parser(self, didParse: [movie])
        return true
    }
}
