//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {

    var imageService: ImageService?
    var movieToDisplay: Movie?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func configure(with movie: Movie, imageService: ImageService) {
        self.movieToDisplay = movie
        self.imageService = imageService
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let movie = movieToDisplay else {
            return
        }
        self.title = movie.title

        updateView(with: movie)
    }

    func updateView(with movie: Movie) {

        titleLabel.text = movie.title
        languageLabel.text = movie.language
        descriptionLabel.text = movie.overview

        self.view.setNeedsDisplay()
        if let path = movie.backdropPath {

            let imageURL = "https://image.tmdb.org/t/p/w500" + path

            imageService?.loadImage(forURL: imageURL, completion: { [weak self](imageUrl, image, error) in

                self?.imageView.image = image
                self?.imageView.setNeedsLayout()
            })
        }
    }
}
