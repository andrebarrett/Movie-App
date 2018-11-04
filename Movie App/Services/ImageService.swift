//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation
import UIKit

enum ImageServiceError: Error {
    case invalidURL
}
typealias ImageCompletion = (String, UIImage?, Error?) -> Void

protocol ImageService {
    func loadImage(forURL urlString: String, completion: @escaping (String, UIImage?, Error?) -> Void)
}

class SimpleImageService: ImageService {

    func loadImage(forURL urlString: String, completion: @escaping (String, UIImage?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(urlString, nil, ImageServiceError.invalidURL)
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in

            var image: UIImage?

            if let imageData = data {
               image = UIImage(data: imageData)
            }

            DispatchQueue.main.async {
                completion(urlString, image, error)
            }
        }

        dataTask.resume()
    }
}
