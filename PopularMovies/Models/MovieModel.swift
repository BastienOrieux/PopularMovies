//
//  MovieModel.swift
//  PopularMovies
//
//  Created by ORIEUX Bastien on 10/3/19.
//  Copyright © 2019 Privalia. All rights reserved.
//

import Foundation
public struct MovieModel: Codable {
    
    var posterPath : String?
    var adult : Bool
    var overview : String
    var releaseDate : String
    var genreIds : [Int]
    var id : Int
    var originalTitle : String
    var originalLanguage : String
    var title : String
    var backdropPath : String?
    var popularity : Float
    var voteCount : Int
    var video : Bool
    var voteAverage : Float
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult = "adult"
        case overview = "overview"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case id = "id"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title = "title"
        case backdropPath = "backdrop_path"
        case popularity = "popularity"
        case voteCount = "vote_count"
        case video = "video"
        case voteAverage = "vote_average"
    }
}
