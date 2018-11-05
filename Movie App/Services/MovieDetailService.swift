//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation

protocol MovieDetailService {
    func getMovieDetails(withID identifier: String, completion: @escaping ServiceCompletion)
}
