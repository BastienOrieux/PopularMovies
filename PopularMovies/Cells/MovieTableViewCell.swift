//
//  MovieTableViewCell.swift
//  PopularMovies
//
//  Created by ORIEUX Bastien on 10/3/19.
//  Copyright © 2019 Privalia. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRelease: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.layer.cornerRadius = 6
        movieImage.clipsToBounds = true
        activityIndicator.hidesWhenStopped = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setFrontPreview (_ movie: MovieModel){
        if let urlImage = movie.posterPath {
            activityIndicator.startAnimating()
            NetworkManager.shared.loadImage(path: urlImage) { (image) in
                if image != nil{
                    self.movieImage.image = image
                    self.activityIndicator.stopAnimating()
                }else{
                    print("error")
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}



