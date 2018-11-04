//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation

enum MovieAttributes {

    static let posterPath = "poster_path"
    static let overview = "overview"
    static let releaseDate = "release_date"
    static let id = "id"
    static let language = "original_language"
    static let title = "title"
    static let backdropPath = "backdrop_path"
    static let popularity = "popularity"

}

struct Movie {

    var id: Int?
    var title: String?
    var releaseDate: String?
    var overview: String?
    var language: String?
    var popularity: Double?
    var posterPath: String?
    var backdropPath: String?
}

extension Movie {

    init(dictionary: [String: AnyObject]) {

        self.id = dictionary[MovieAttributes.id] as? Int
        self.title = dictionary[MovieAttributes.title] as? String
        self.releaseDate = dictionary[MovieAttributes.releaseDate] as? String
        self.overview = dictionary[MovieAttributes.overview] as? String
        self.language = dictionary[MovieAttributes.language] as? String
        self.popularity = dictionary[MovieAttributes.popularity] as? Double
        self.posterPath = dictionary[MovieAttributes.posterPath] as? String
        self.backdropPath = dictionary[MovieAttributes.backdropPath] as? String
    }
}
