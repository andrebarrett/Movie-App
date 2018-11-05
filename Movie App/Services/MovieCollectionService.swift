//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation

protocol MovieCollectionService {
    func getMovieCollection(withId identifier: String, completion: @escaping ServiceCompletion)
}
