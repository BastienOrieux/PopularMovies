//
//  PopularMovieModel.swift
//  PopularMovies
//
//  Created by ORIEUX Bastien on 10/3/19.
//  Copyright © 2019 Privalia. All rights reserved.
//

import Foundation

public struct PopularMovieModel : Codable {
    var page : Int
    var results : [MovieModel]
    var totalResults : Int
    var totalPages : Int
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
