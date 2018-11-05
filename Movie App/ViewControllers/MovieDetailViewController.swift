//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {

    var imageService: ImageService?
    var movieService: (MovieDetailService & MovieCollectionService)?
    var movieToDisplay: Movie?
    var moviesCollection = [Movie]()


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    func configure(with movie: Movie, imageService: ImageService, movieService: (MovieDetailService & MovieCollectionService)) {

        self.movieToDisplay = movie
        self.imageService = imageService
        self.movieService = movieService
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let movie = movieToDisplay else {
            return
        }
        self.title = movie.title

        updateView(with: movie)

        guard let movieID = movie.id else { return }

        movieService?.getMovieDetails(withID: "\(movieID)", completion: { (error) in

        })
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

extension MovieDetailViewController: MovieServiceParserDelegate {

    func parser(_ parser: ServiceParser, didParse movies: [Movie]) {
        moviesCollection = movies
    }

    func parser(_ parser: ServiceParser, didParseCollectionWithId identifier: String, forMovie movie: Movie) {

        movieService?.getMovieCollection(withId: identifier, completion: { [weak self] (error) in
            self?.tableView.reloadData()
        })
    }
}

extension MovieDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesCollection.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCellReuseIdentifier") {

            let movie = moviesCollection[indexPath.row]

            cell.textLabel?.text = movie.title

            if let path = movie.posterPath {

                let imageURL = "https://image.tmdb.org/t/p/w500" + path

                imageService?.loadImage(forURL: imageURL, completion: { (imageUrl, image, error) in

                    cell.imageView?.image = image
                })
            }

            return cell
        }

        return UITableViewCell()
    }
}

extension MovieDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let movie = moviesCollection[indexPath.row]

        let networkService = SimpleNetworkService()
        let serviceParser = MovieServiceParser()
        let movieService = MovieService(networkService: networkService, serviceParser: serviceParser)

        guard let detailController = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardViewController.MovieDetailViewController) as? MovieDetailViewController, let imageService = self.imageService  else { return }

        detailController.configure(with: movie, imageService: imageService, movieService: movieService)
        serviceParser.delegate = detailController

        self.navigationController?.pushViewController(detailController, animated: true)
    }
}
