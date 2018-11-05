//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation

protocol ServiceParser {
    func parseMovieDataDictionary(_ dictionary: [String: AnyObject]) -> Bool

    func parseMovieDetailsDictionary(_ dictionary: [String: AnyObject]) -> Bool

    func parseMovieCollectionsDictionary(_ dictionary: [String: AnyObject]) -> Bool
}
