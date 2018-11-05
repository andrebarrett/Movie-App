//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation

class MovieService: NowPlayingMovieService, MovieDetailService, MovieCollectionService {

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

                let dataDictionary = try self.parse(data: data)

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

    func getMovieDetails(withID identifier: String, completion: @escaping ServiceCompletion) {

        let urlString = BASE_URL + VersionPath + MovieDetailsQuery
        let urlStringWithMovieID = urlString.replacingOccurrences(of: "$MOVIE_ID", with: identifier)
        let urlStringWithAPIKey = urlStringWithMovieID.replacingOccurrences(of: "$API_KEY", with: API_KEY)

        guard let url = URL(string: urlStringWithAPIKey) else {
            return
        }

        let urlRequest = URLRequest(url: url)

        networkService.fethDataForURLRequest(urlRequest) { [weak self](data, error) in

            var errorOptional = error

            do {
                guard let `self` = self else { return }

                let dataDictionary = try self.parse(data: data)

                let success = self.serviceParser.parseMovieDetailsDictionary(dataDictionary)

                guard success else { throw ServiceError.parseError }

            } catch {
                errorOptional = error
            }

            DispatchQueue.main.async {
                completion(errorOptional)
            }
        }
    }

    func getMovieCollection(withId identifier: String, completion: @escaping ServiceCompletion) {

        let urlString = BASE_URL + VersionPath + MovieCollectionsQuery
        let urlStringWithCollectionID = urlString.replacingOccurrences(of: "$COLLECTION_ID", with: identifier)
        let urlStringWithAPIKey = urlStringWithCollectionID.replacingOccurrences(of: "$API_KEY", with: API_KEY)

        guard let url = URL(string: urlStringWithAPIKey) else {
            return
        }

        let urlRequest = URLRequest(url: url)

        networkService.fethDataForURLRequest(urlRequest) { [weak self](data, error) in

            var errorOptional = error

            do {
                guard let `self` = self else { return }

                let dataDictionary = try self.parse(data: data)

                let success = self.serviceParser.parseMovieCollectionsDictionary(dataDictionary)

                guard success else { throw ServiceError.parseError }

            } catch {
                errorOptional = error
            }

            DispatchQueue.main.async {
                completion(errorOptional)
            }
        }
    }

    func parse(data: Data?) throws -> [String: AnyObject] {

        guard let jsonData = data else { throw ServiceError.noData }
        let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)

        guard let dataDictionary = jsonResult as? [String: AnyObject] else { throw ServiceError.parseError }

        return dataDictionary
    }
}
