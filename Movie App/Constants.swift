//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation

let API_KEY = "7d758c986ac4f389a8ffe19bbf626715"
let API_READ_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3ZDc1OGM5ODZhYzRmMzg5YThmZmUxOWJiZjYyNjcxNSIsInN1YiI6IjViZGQ4MzdjMGUwYTI2MDU4ZjAwYWU1NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.KkLg7vbErID5hkFe0S1xWPAw83Ot1tY_f7w5sAoWvFk"

let BASE_URL = "https://api.themoviedb.org"
let VersionPath = "/3/"
let NowPlayingQuery = "movies/get-now-playing?api_key=$API_KEY"

enum StoryBoardViewController {
    static let MovieCollectionViewController = "MovieCollectionViewController"
    static let MovieDetailViewController = "MovieDetailViewController"
}
