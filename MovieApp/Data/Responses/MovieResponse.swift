//
//  MovieResponse.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation

struct MovieResponse : Codable {
    
    var id : Int
    var title : String
    var overview : String
    var posterUrl : String
    var releaseDate : String
    var genres : [GenreResponse]?
    var voteAvg : Double
    var voteCount : Int
    var videos : [String : [VideoResponse]]?
    var reviews : ReviewListResponse?
    
    
    
    enum CodingKeys : String, CodingKey {
        case id
        case title
        case overview
        case posterUrl = "poster_path"
        case releaseDate = "release_date"
        case genres
        case voteAvg = "vote_average"
        case voteCount = "vote_count"
        case videos
        case reviews
    }
    
    func toEntity() -> Movie {
        return Movie(
            id: id,
            title: title,
            overview: overview,
            posterUrl: "\(App.imageBaseUrl + posterUrl)",
            releaseDate: releaseDate.convertToDate() ?? Date(),
            genres: genres?.map({ $0.name }),
            voteAvg: voteAvg,
            voteCount: voteCount,
            videos: videos?.values.first!.filter({ value in value.site == "YouTube" && value.type == "Trailer" }).map({ $0.toEntity() }),
            displayedreview: reviews?.results.first?.toEntity()
         )
    }
}



