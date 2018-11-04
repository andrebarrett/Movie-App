//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation
import UIKit

class MovieCollectionViewController: UICollectionViewController {

    var imageService: ImageService?
    var movieService: NowPlayingMovieService?
    var moviesToDisplay = [Movie]()

    override func awakeFromNib() {
        super.awakeFromNib()

        let networkService = SimpleNetworkService()
        let serviceParser = MovieServiceParser()
        let movieService = NowPlayingMovieServiceImpl(networkService: networkService, serviceParser: serviceParser)
        serviceParser.delegate = self

        let imageService = SimpleImageService()

        configure(with: movieService, imageService: imageService)
    }


    func configure(with movieService: NowPlayingMovieService, imageService: ImageService) {
        self.movieService = movieService
        self.imageService = imageService
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadData() {

        movieService?.getNowPlayingMovies(completion: { [weak self] (error) in

            if let _ = error {

                self?.handleError()
            } else {
                self?.collectionView.reloadData()
            }
        })
    }

    func handleError() {

        let alertController = UIAlertController(title: "Error", message: "An error occured. Please try again", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: { [weak self](action) in

            self?.loadData()
            alertController.dismiss(animated: true, completion: nil)
        })

        alertController.addAction(tryAgainAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            alertController.dismiss(animated: true, completion: nil)
        })

        present(alertController, animated: true, completion: nil)
    }

}

extension MovieCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let movie = moviesToDisplay[indexPath.row]

        guard let detailController = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardViewController.MovieDetailViewController) as? MovieDetailViewController, let imageService = self.imageService  else { return }

        detailController.configure(with: movie, imageService: imageService)

        self.navigationController?.pushViewController(detailController, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        guard let movieCell = cell as? MovieCollectionViewControllerCell else { return }
        let movie = moviesToDisplay[indexPath.row]

        movieCell.titleLabel?.text = movie.title

        if let path = movie.posterPath {

            let posterImageURL = "https://image.tmdb.org/t/p/w500" + path
            movieCell.imageURL = posterImageURL

            imageService?.loadImage(forURL: posterImageURL, completion: { (imageUrl, image, error) in

                if movieCell.imageURL == imageUrl {
                    movieCell.imageView?.image = image
                }
            })
        }
    }
}

extension MovieCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesToDisplay.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let reuseIdentifier = "MovieCollectionViewControllerCellReuseIdentifier"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        return cell
    }
}


extension MovieCollectionViewController: MovieServiceParserDelegate {

    func parser(_ parser: ServiceParser, didParse: [Movie]) {
        moviesToDisplay = didParse
    }
}
