//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation

enum MovieResponseAttributes {
    static let Results = "results"
}

protocol MovieServiceParserDelegate {

    func parser(_ parser:ServiceParser, didParse movies: [Movie])
}

class MovieServiceParser: ServiceParser {

    var delegate: MovieServiceParserDelegate?

    func parseDataDictionary(_ dictionary: [String : AnyObject]) -> Bool {

        var success = false

        if let albumArray = dictionary[MovieResponseAttributes.Results] as? [Dictionary<String, AnyObject>] {

            parseMovies(movieData: albumArray)
            success = true

        }

        return success
    }

    private func parseMovies(movieData: [Dictionary<String, AnyObject>]) {

        var movieArray = [Movie]()

        for dictionary: [String: AnyObject] in movieData {

            let movie = Movie(dictionary: dictionary)
            movieArray.append(movie)
        }

        delegate?.parser(self, didParse: movieArray)
    }
}
