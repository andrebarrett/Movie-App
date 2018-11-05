//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation

enum MovieResponseAttributes {
    static let Results = "results"
    static let Collections = "parts"
}

protocol MovieServiceParserDelegate {

    func parser(_ parser:ServiceParser, didParse movies: [Movie])

    func parser(_ parser:ServiceParser, didParseCollectionWithId identifier: String, forMovie movie: Movie)
}

class MovieServiceParser: ServiceParser {

    var delegate: MovieServiceParserDelegate?

    func parseMovieDataDictionary(_ dictionary: [String : AnyObject]) -> Bool {

        var success = false

        if let albumArray = dictionary[MovieResponseAttributes.Results] as? [Dictionary<String, AnyObject>] {

            let movieArray = parseMovies(movieData: albumArray)
            delegate?.parser(self, didParse: movieArray)

            success = true
        }

        return success
    }

    private func parseMovies(movieData: [Dictionary<String, AnyObject>]) -> [Movie] {

        var movieArray = [Movie]()

        for dictionary: [String: AnyObject] in movieData {

            let movie = Movie(dictionary: dictionary)
            movieArray.append(movie)
        }

        return movieArray
    }

    func parseMovieDetailsDictionary(_ dictionary: [String : AnyObject]) -> Bool {

        let movie = Movie(dictionary: dictionary)

        if let collectionData = dictionary["belongs_to_collection"] as? [String: AnyObject] {

            if let collectionId = collectionData["id"] as? Int {
                delegate?.parser(self, didParseCollectionWithId: "\(collectionId)", forMovie: movie)
            }
        }

        return true
    }

    func parseMovieCollectionsDictionary(_ dictionary: [String : AnyObject]) -> Bool {

        var success = false

        if let albumArray = dictionary[MovieResponseAttributes.Collections] as? [Dictionary<String, AnyObject>] {

            let movieArray = parseMovies(movieData: albumArray)
            delegate?.parser(self, didParse: movieArray)

            success = true
        }

        return success
    }
}
