//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case noData
    case parseError
}

typealias ServiceCompletion = (Error?) -> Void

protocol NowPlayingMovieServiceDelegate {
    func nowPlayingService(_ service: NowPlayingMovieService, didReceiveMovies: [Movie])
}

protocol NowPlayingMovieService {
    func getNowPlayingMovies(completion: @escaping ServiceCompletion)
}

class NowPlayingMovieServiceImpl: NowPlayingMovieService {

    var delegate: NowPlayingMovieServiceDelegate?

    private let networkService: NetworkService
    internal var serviceParser: ServiceParser

    init(networkService: NetworkService, serviceParser: ServiceParser) {
        self.networkService = networkService
        self.serviceParser = serviceParser
    }

    func getNowPlayingMovies(completion: @escaping ServiceCompletion) {

        let urlString = BASE_URL + VersionPath + NowPlayingQuery
        let urlStringWithAPIKey = urlString.replacingOccurrences(of: "$API_KEY", with: API_KEY)

        guard let url = URL(string: urlStringWithAPIKey) else {
            return
        }

        let urlRequest = URLRequest(url: url)

        networkService.fethDataForURLRequest(urlRequest) { [weak self](data, error) in

            var errorOptional = error

            do {
                guard let `self` = self else { return }

                guard let jsonData = data else { throw ServiceError.noData }
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)

                guard let dataDictionary = jsonResult as? [String: AnyObject] else { throw ServiceError.parseError }

                let success = self.serviceParser.parseMovieDataDictionary(dataDictionary)

                guard success else { throw ServiceError.parseError }

            } catch {
                errorOptional = error
            }

            DispatchQueue.main.async {
                completion(errorOptional)
            }
        }
    }
}
