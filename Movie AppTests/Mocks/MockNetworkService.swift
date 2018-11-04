//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation
@testable import Movie_App

class MockNetworkService: NetworkService {

    var dataToReturn: Data?
    var errorToReturn: Error?
    var urlRequestMade: URLRequest?

    func fethDataForURLRequest(_ urlRequest: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        self.urlRequestMade = urlRequest
        completion(dataToReturn, errorToReturn)
    }
}
