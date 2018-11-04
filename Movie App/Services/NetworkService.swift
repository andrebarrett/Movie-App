//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation

typealias NetworkServiceCompletion = (Data?, Error?) -> Void

protocol NetworkService {
    func fethDataForURLRequest(_ urlRequest: URLRequest, completion: @escaping NetworkServiceCompletion)
}

class SimpleNetworkService: NetworkService {

    func fethDataForURLRequest(_ urlRequest: URLRequest, completion: @escaping (Data?, Error?) -> Void) {

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

            completion(data, error)
        }

        dataTask.resume()
    }
}
